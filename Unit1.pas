unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, DateUtils, Math, StdCtrls, ScktComp, ComCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ZConnection1: TZConnection;
    ZConnection2: TZConnection;
    misc: TZQuery;
    que: TZQuery;
    ZQuery2: TZQuery;
    mysqlserver: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    ClientSocket1: TClientSocket;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit3: TEdit;
    ClientSocket2: TClientSocket;
    Button8: TButton;
    Button9: TButton;
    Button14: TButton;
    Button15: TButton;
    Edit4: TEdit;
    Button10: TButton;
    Edit5: TEdit;
    Button11: TButton;
    fo: TZQuery;
    rsv: TZQuery;
    dep: TDateTimePicker;
    Button12: TButton;
    Timer2: TTimer;
    Label2: TLabel;
    procedure Timer2Timer(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ClientSocket2Write(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ClientSocket2Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button8Click(Sender: TObject);
    procedure ClientSocket2Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ClientSocket2Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button5Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button4Click(Sender: TObject);
    procedure ClientSocket1Connecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    runningfo : Boolean;
    runningbilling : Boolean;
    procedure ParseRAW;
    procedure getAreaCost(ph: String;dur:String;var area:String;var Cost:Double;ctg:Integer);
    procedure InsertRAW(s: String);
    procedure Sinkro;
    procedure ParseRoom;
    procedure CO(roomno: String);
    procedure CI(roomno,name:String;cidt,codt:TDate);
    procedure MULAI;
    procedure SELESAI;
    procedure BUKA(roomno: String);
    procedure TUTUP(roomno: String);
    procedure CHG(roomno,nama: String);

  end;

var
  Form1: TForm1;

const
   RS = '|';
   STX = Chr(2);
   ETX = Chr(3);
   LRC = Chr(13);
   SPC = Chr(32);
   ENQ = Chr(5);
   ACK = Chr(6);
   NAK = Chr(21);

implementation

{$R *.dfm}

function String2Hex(const Buffer: Ansistring): string;
begin
  SetLength(result, 2*Length(Buffer));
  BinToHex(@Buffer[1], @result[1], Length(Buffer));
end;

function HexToString(H: String): String;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (H) div 2 do
    Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ParseRAW;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  ParseRoom;
end;

procedure TForm1.ParseRAW;
var cmd : String;
    datestr,durstr,timestr : String;
    dt : TDate;
    room,tm,dur,dial,room2: String;
    dd,mm,yy : Word;
    hh,nn,ss : String;
    id : Integer;
    area: String;
    cost: Double;
//    roomprefix : String;
    smdrid : String;
    smdridint : Integer;
    cnt : Integer;

begin
  //parsing raw data


  Application.ProcessMessages;

  if que.Active then que.Close;
//  que.SQL.Text := 'select id,substr(smdr,7,3) as roomno, substr(smdr,6,1) as roomprefix,substr(smdr,19,8) as duration, substr(smdr,28,8) as tgl, substr(smdr,37,5) as jam,' +
//                  ' substr(smdr,47,14) as ph, substr(smdr,46,1) as type' +
//                  ' from pbxraw where processed=0 having type=''O''';
//                  //and left(smdr,1)=''0''


  que.SQL.Text := 'select id, substr(smdr,1,2) as smdrid, substr(smdr,36,10) as roomno,current_date as tgl,substr(smdr,10,5) as jam,substr(smdr,27,8) as duration,substr(smdr,47,12) as ph, substr(smdr,1,2) as no' +
                  ' from pbxraw' +
                  ' where processed=0 and trim(substr(smdr,1,2)) REGEXP ''[0-9]+''' +
                  ' and smdr not like ''%NO ANSWER%''';
  que.Open;

  que.First;

  if que.RecordCount>0 then begin
    Memo1.Lines.Clear;
    Timer1.Enabled := False;
    cnt := que.RecordCount;
  end;

  Label2.Caption := '0 records remaining';


  while not que.Eof do begin

    if runningbilling=False then Exit;


//    Memo1.Lines.Add(IntToStr(que['id'])+' '+que['smdrid']);

    smdrid := que['smdrid'];
    if TryStrToInt(smdrid,smdridint) = false then begin
      que.Next;
      Continue;
    end;

    id := que['id'];
    room := que['roomno'];
    room2 := Copy(room,6,3);
    datestr := que['tgl'];
    tm := que['jam'];
//    roomprefix := que['roomprefix'];

//    mm := StrToInt(Copy(datestr,1,2));
//    dd := StrToInt(Copy(datestr,4,2));
//    yy := StrToInt('20'+Copy(datestr,7,2));

    dt := Now;
//    dt := EncodeDate(yy,mm,dd);
    dur := que['duration'];
    dial := que['ph'];

    //get area
    //getAreaCost(dial,dur,area,cost);
    //get area

    if misc.Active then misc.Close;
      misc.SQL.Clear;
      misc.SQL.Add('select roomno from fosroom where roomno='+QuotedStr(room2));
      misc.Open;
      if (misc.RecordCount>0) and (dur <> '00:00:00') then begin

        room := room2;

        getAreaCost(dial,dur,area,cost,0);

        cmd := 'INSERT INTO tms2fo (`code`, `room`, `date`, `time`, `duration`, `dial`, `cost`, `service`, `tax`, `note`, `type`, `flag`) '+
               ' VALUES (' + QuotedStr('C') +
               ',' + QuotedStr(room)+
               ',' + QuotedStr(FormatDateTime('yyyy-mm-dd',dt))+
               ',' + QuotedStr(tm) +
               ',' + QuotedStr(dur) +
               ',' + QuotedStr(dial) +
               ',' + FloatToStr(cost) +
               ',0,0'+
               ',' + QuotedStr(area)+
               ',' + QuotedStr('')+
               ',' + IntToStr(1)+
               ')';

        if ZConnection2.Connected then
        ZConnection2.ExecuteDirect(cmd);
        Application.ProcessMessages;



      end
      else if (misc.RecordCount=0) then begin

        getAreaCost(dial,dur,area,cost,1);

        cmd := 'INSERT INTO tms2fo2 (`code`, `room`, `date`, `time`, `duration`, `dial`, `cost`, `service`, `tax`, `note`, `type`, `flag`) '+
               ' VALUES (' + QuotedStr('C') +
               ',' + QuotedStr(room)+
               ',' + QuotedStr(FormatDateTime('yyyy-mm-dd',dt))+
               ',' + QuotedStr(tm) +
               ',' + QuotedStr(dur) +
               ',' + QuotedStr(dial) +
               ',' + FloatToStr(cost) +
               ',0,0'+
               ',' + QuotedStr(area)+
               ',' + QuotedStr('')+
               ',' + IntToStr(1)+
               ')';

        if ZConnection2.Connected then
          ZConnection2.ExecuteDirect(cmd);

      end;

      cmd := 'update pbxraw set processed=1 where id='+IntToStr(id);
      if ZConnection1.Connected then
        ZConnection1.ExecuteDirect(cmd);

      Application.ProcessMessages;


      misc.Close;
      Memo1.Lines.Add('Charging '+ room + ' ' +dial);
      cnt := cnt-1;
      Label2.Caption := IntToStr(cnt)+ ' records remaining';

    que.Next;
  end;

//  que.Close;
  Timer1.Enabled := True;



end;


procedure TForm1.Button10Click(Sender: TObject);
var str : String;
    lenspc : Integer;
begin
  str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

  lenspc := 8 - Length(Trim(Edit3.Text));

  str := STX+'STS'+Trim(Edit4.Text)+SPC+Trim(Edit3.Text)+StringOfChar(SPC,lenspc)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

  str := STX+'END'+StringOfChar(SPC,7)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);

end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Sinkro;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  CI('208','TITIK EMERALD 12345678901234',dep.Date,dep.Date);
end;

procedure TForm1.Button14Click(Sender: TObject);
var str : String;
begin
  str := STX+'RQINZ'+StringOfChar(SPC,5)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);

end;

procedure TForm1.Button15Click(Sender: TObject);
var str : String;
    lenspc :Integer;
begin
  str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

  lenspc := 8 - Length(Trim(Edit3.Text));

  str := STX+'RST'+Trim(Edit4.Text)+SPC+Trim(Edit3.Text)+StringOfChar(SPC,lenspc)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

  str := STX+'END'+StringOfChar(SPC,7)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  runningbilling := True;
  Timer1.Enabled := True;
  Button1.Enabled := False;
  Button2.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  runningbilling := False;
  Timer1.Enabled := False;
  Button1.Enabled := True;
  Button2.Enabled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ClientSocket1.Host := Edit1.Text;
  ClientSocket1.Port := StrToInt(Edit2.Text);
  ClientSocket1.Open;

  if ClientSocket1.Active then begin
    Button3.Enabled := False;
    Button4.Enabled := True;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ClientSocket1.Close;
  if not ClientSocket1.Active then begin
    Button3.Enabled := True;
    Button4.Enabled := False;

  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ClientSocket2.Host := Edit1.Text;
  ClientSocket2.Port := 5129;
  ClientSocket2.Open;
  ParseRoom;
  Timer2.Enabled := True;

end;

procedure TForm1.Button6Click(Sender: TObject);
var str : String;
    cntspc : Integer;
    guestname : String;
begin



  if ClientSocket2.Active then begin
//    str := STX + '1' + '!' + 'L' + '1' + '6' + '1' + '1' + '1' + Trim(Edit3.Text) + StringOfChar(SPC,3)+ ETX + LRC;
    str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);
    Sleep(100);

    guestname := Copy('ARGA EMERALD',1,20);
    cntspc := 20 - Length(guestname);

    str := STX+'CHK'+'1'+SPC+Trim(Edit3.Text)+StringOfChar(SPC,4)+guestname+StringOfChar(SPC,cntspc)+ETX;
//    str := STX+'CHK'+'1'+SPC+Trim(Edit3.Text)+StringOfChar(SPC,4)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);
    Sleep(100);

    str := STX+'END'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);    
    Sleep(100);
  end
  else begin
    ShowMessage('PMS is not connected');
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var str : String;
begin
 if ClientSocket2.Active then begin
//    str := STX + '1' + '!' + 'L' + '1' + '6' + '1' + '1' + '2' + Trim(Edit3.Text) + StringOfChar(SPC,3)+ ETX + LRC;
    str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Sleep(500);

    str := STX+'CHK'+'0'+SPC+Trim(Edit3.Text)+StringOfChar(SPC,4)+ETX;
    ClientSocket2.Socket.SendText(str);
    Sleep(500);

    str := STX+'END'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Sleep(500);
  end
  else begin
    ShowMessage('PMS is not connected');
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var str : String;
begin
  if ClientSocket2.Active then begin
    str := ENQ;
    ClientSocket2.Socket.SendText(str);
  end
  else begin
    ShowMessage('PMS is not connected');
  end;
  
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(STX+'AREYUTHERE'+ETX);
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('SMDR Port Connected');
end;

procedure TForm1.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('SMDR Port Connecting....');
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('SMDR Port Disconnected');
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var terima : String;
begin
  terima := Socket.ReceiveText;
  Memo1.Lines.Add(FormatDateTime('dd-mm-yyyy hh:nn:ss',Now)+' <-- '+terima);
  InsertRAW(terima);
end;

procedure TForm1.ClientSocket2Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('PABX Port connected');
end;

procedure TForm1.ClientSocket2Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('PABX Port disconnected');
end;

procedure TForm1.ClientSocket2Read(Sender: TObject; Socket: TCustomWinSocket);
var oritext,bodytext : String;
    str : String;
begin

  oritext := Socket.ReceiveText;
  Memo1.Lines.Add(TimeToStr(Now)+ ' PABX answer :'+ oritext);

  if oritext = ACK then begin
    Memo1.Lines.Add(TimeToStr(Now) +'ACK received');
  end;

  if oritext = NAK then begin
    Memo1.Lines.Add(TimeToStr(Now) +' NAK received');
  end;

  if oritext = STX+'AREYUTHERE'+ETX then begin
    ClientSocket2.Socket.SendText(ACK);
    Memo1.Lines.Add(TimeToStr(Now) +'PMS Receiving AREYUTHERE and Sending ACK');
  end;

  if oritext = STX+'LINETEST  '+ETX then begin
    ClientSocket2.Socket.SendText(ACK);
    Memo1.Lines.Add(TimeToStr(Now) +'PMS Receiving LINETEST and Sending ACK');
  end;

  if Copy(oritext,1,3)=STX+'MW' then begin
    ClientSocket2.Socket.SendText(ACK);
    Memo1.Lines.Add(TimeToStr(Now) +'PMS Receiving MW and Sending ACK');
  end;

  if copy(oritext,1,6) = STX+'RQINZ' then begin
//    Sinkro;
//    ClientSocket2.Close;
  end;






end;

procedure TForm1.ClientSocket2Write(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('sending at '+TimeToStr(Now));
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  Button6.Caption := 'CI '+Edit3.Text;
  Button7.Caption := 'CO '+Edit3.Text;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Edit3Change(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
var x : TStrings;
begin
  if not FileExists('hostn.txt') then begin
    ShowMessage('Configuration file not found');
    Application.Terminate;
  end;

  x := TStringList.Create;
  x.LoadFromFile('hostn.txt');
  mysqlserver.Text := x.Strings[0];

  ZConnection1.HostName := mysqlserver.Text;
  ZConnection1.User := 'apps';
  ZConnection1.Password := 'AlfamartSerayu123';
  ZConnection1.Database := 'pbx';
  ZConnection1.Connected := True;

  ZConnection2.HostName := mysqlserver.Text;
  ZConnection2.User := 'apps';
  ZConnection2.Password := 'AlfamartSerayu123';
  ZConnection2.Database := x.Strings[1];
  ZConnection2.Connected := True;

  if FileExists('lg.log') = True then begin
    RenameFile('lg.log','alc-'+FormatDateTime('ddmmyyhhnn',Now)+'.log');
  end;
end;

procedure TForm1.getAreaCost(ph: String;dur:String;var area:String;var Cost:Double;ctg:Integer);
var zone : Integer;
    duration: Double;
    duration_minutes: Integer;
begin
  //Get Area based on Phone number


     duration := SecondOfTheDay(StrToTime(dur)) / 60;
     duration_minutes := Ceil(duration);

    if Copy(ph,1,1)<>'0' then begin
      area := 'LOCAL';
      case ctg of
        0 : zone := 6;
        1 : zone := 13;
      end;

    end
    else if Copy(ph,1,2)='08' then begin
      area := 'CELLULAR';
      case ctg of
        0 : zone := 7;
        1 : zone := 14;
      end;

    end


    else begin

      if ZQuery2.Active then ZQuery2.Close;
      ZQuery2.SQL.Text := 'select zonecd,zonecd2,ifnull(areadesc,'''') as areadesc from areacode where areacd='+QuotedStr(Copy(ph,2,2));
      ZQuery2.Open;
      if ZQuery2.RecordCount>0 then begin
        area := ZQuery2['areadesc'];
        case ctg of
          0 : zone := ZQuery2['zonecd'];
          1 : zone := ZQuery2['zonecd2'];
        end;

      end
      else begin
        if ZQuery2.Active then ZQuery2.Close;
        ZQuery2.SQL.Text := 'select zonecd,zonecd2,ifnull(areadesc,'''') as areadesc from areacode where areacd='+QuotedStr(Copy(ph,2,3));
        ZQuery2.Open;
        if ZQuery2.RecordCount>0 then begin
          area := ZQuery2['areadesc'];
          case ctg of
            0 : zone := ZQuery2['zonecd'];
            1 : zone := ZQuery2['zonecd2'];
          end;
        end;
      end;
    end;

    if ZQuery2.Active then ZQuery2.Close;
    ZQuery2.SQL.Text := 'select amt from zonemaster where zonecd='+IntToStr(zone);
    ZQuery2.Open;
    if ZQuery2.RecordCount>0 then begin
      Cost := ZQuery2['amt'] * duration_minutes;
    end
    else begin
      Cost := 0;
    end;

end;


procedure TForm1.InsertRAW(s: String);
begin
  //


  if ZConnection1.Connected then begin

  ZConnection1.ExecuteDirect('insert into pbxraw (trdt,smdr) ' +
                  ' values ('+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now))+
                  ','+QuotedStr(s)+
                  ')');
  end;




end;

procedure TForm1.Sinkro;
var kamar : TZQuery;
    str,roomno,stat : String;
begin
  kamar := TZQuery.Create(Self);
  kamar.Connection := ZConnection2;

  kamar.SQL.Text := 'select * from fosroom';
  kamar.Open;
  kamar.First;

  str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
  ClientSocket2.Socket.SendText(str);
  Memo1.Lines.Add(str);
  Sleep(100);

  while not kamar.Eof do begin

    roomno := kamar.FieldByName('roomno').AsString;

    if kamar.FieldByName('roomstfo1').AsString='V' then
      stat := '0'
    else
      stat := '1';

    if roomno = '208' then
      stat := '0';
    

    str := STX+'CHK'+stat+SPC+Trim('8'+roomno)+StringOfChar(SPC,4)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);
    Sleep(100);

    kamar.Next;

  end;

  str := STX+'END'+StringOfChar(SPC,7)+ETX;
  ClientSocket2.Socket.SendText(str);
  Memo1.Lines.Add(str);




end;


procedure TForm1.ParseRoom;
var depdt : TDate;
begin
  //
  runningfo:=True;
  if fo.Active then fo.Close;
  fo.SQL.Text := 'select * from room where flag=1';
  fo.Open;
  fo.First;
  while not fo.Eof do begin

    if runningfo=False then Exit;

    if rsv.Active then rsv.Close;
    rsv.SQL.Text := 'select depdt from fofrsv where rsvst=''R'' and roomno='+QuotedStr(fo['room'])+' limit 1';
    rsv.Open;
    if rsv.RecordCount<1 then begin
      fo.Next;
      Continue;
    end;

    depdt := rsv['depdt'];
    rsv.Close;

    //di NEC BSH 0=10 = BUKA
    //           3=13 = TUTUP

    if (fo['type'] = 'I') and (fo['cos'] = '3') then begin
      MULAI;
      CI(fo['room'],fo['name'],Now,depdt);
      BUKA(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;

    if (fo['type'] = 'I') and (fo['cos'] = '0') then begin
      MULAI;
      CI(fo['room'],fo['name'],Now,depdt);
      TUTUP(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;

    if (fo['type'] = 'O') and (fo['cos'] = '3') then begin
      MULAI;
      CO(fo['room']);
      TUTUP(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;

    if (fo['type'] = 'O') and (fo['cos'] = '0') then begin
      MULAI;
      CO(fo['room']);
      TUTUP(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;


    if (fo['type'] = 'C') and (fo['cos'] = '0') then begin
      MULAI;
      //CO(fo['room']);
      TUTUP(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;


    if (fo['type'] = 'C') and (fo['cos'] = '3') then begin
      MULAI;
//      CI(fo['room'],fo['name'],Now,depdt);
      BUKA(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;

    if (fo['type'] = 'N') and (fo['cos'] = '3') then begin
      MULAI;
      CHG(fo['room'],fo['name']);
      BUKA(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;

    if (fo['type'] = 'N') and (fo['cos'] = '0') then begin
      MULAI;
      CHG(fo['room'],fo['name']);
      TUTUP(fo['room']);
      SELESAI;
      ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
      Application.ProcessMessages;
      Sleep(500);
      fo.Next;
      Continue;
    end;


    ZConnection2.ExecuteDirect('update room set flag=0 where id='+IntToStr(fo['id']));
    Application.ProcessMessages;
    Sleep(500);
    fo.Next;


  end;
end;


procedure TForm1.CI(roomno,name:String;cidt,codt:TDate);
var str: String;
    guestname : String;
    i : Integer;
    cntspc : Integer;
begin
  {Check In String
    Room : 8208
    Name : TITIK EMERALD (
    <STX>CHK1 8208xxxxTITIK EMERALDsssssss<ETX>
  }

  if ClientSocket2.Active then begin


    roomno := '8'+roomno;
    guestname := Copy(name,1,20);
    cntspc := 20 - Length(guestname);
    str := STX+'CHK'+'1'+SPC+roomno+StringOfChar(SPC,4)+guestname+StringOfChar(SPC,cntspc)+ETX;
    Memo1.Lines.Add(str);
    ClientSocket2.Socket.SendText(str);
    Sleep(100);


  end
  else begin
    Memo1.Lines.Add('Not connected');
  end;

end;

procedure TForm1.CO(roomno: String);
var str: String;
    guestname : String;
    i : Integer;
    cntspc : Integer;

begin
  {Check Out String
    Room : 8208
    Name : TITIK EMERALD (
    <STX>CHK0 8208xxxxTITIK EMERALDsssssss<ETX>
  }

  if ClientSocket2.Active then begin

    roomno := '8'+roomno;
    guestname := Copy(name,1,20);
    cntspc := 20 - Length(guestname);
    str := STX+'CHK'+'0'+SPC+roomno+StringOfChar(SPC,4)+guestname+StringOfChar(SPC,cntspc)+ETX;
    Memo1.Lines.Add(str);
    ClientSocket2.Socket.SendText(str);
    Sleep(100);

  end
  else begin
    Memo1.Lines.Add('Not connected');
  end;
end;



procedure TForm1.MULAI;
var str : String;
begin
  //
    str := STX+'GRS'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);
    Sleep(100);
end;

procedure TForm1.SELESAI;
var str : String;
begin
  //
    str := STX+'END'+StringOfChar(SPC,7)+ETX;
    ClientSocket2.Socket.SendText(str);
    Memo1.Lines.Add(str);
    Sleep(100);
end;

procedure TForm1.BUKA(roomno: String);
var str: String;
    lenspc : Integer;
    kamar : String;
begin
  kamar := '8'+roomno;
  lenspc := 8 - Length(kamar);

  str := STX+'RST'+'0'+SPC+Trim(kamar)+StringOfChar(SPC,lenspc)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

end;

procedure TForm1.TUTUP(roomno: String);
var str: String;
    lenspc : Integer;
    kamar: String;
begin
  kamar := '8'+roomno;
  lenspc := 8 - Length(kamar);

  str := STX+'RST'+'3'+SPC+Trim(kamar)+StringOfChar(SPC,lenspc)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);

end;

procedure TForm1.CHG(roomno: string; nama: string);
var kamar,guestname : String;
    lenspc,cntspc : Integer;
    str : String;
begin
  //
  kamar := '8'+roomno;
  lenspc := 8 - Length(kamar);
  guestname := Copy(name,1,20);
  cntspc := 20 - Length(guestname);
  str := STX+'CHK'+'1'+SPC+roomno+StringOfChar(SPC,4)+guestname+StringOfChar(SPC,cntspc)+ETX;

  str := STX+'EDT'+'1'+SPC+Trim(kamar)+StringOfChar(SPC,lenspc)+guestname+StringOfChar(SPC,cntspc)+ETX;
  Memo1.Lines.Add('PMS Sent '+ IntToStr(Length(str))+' '+str);
  ClientSocket2.Socket.SendText(str);
  Sleep(200);
end;



end.
