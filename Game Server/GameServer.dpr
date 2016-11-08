 program GameServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SimpleShareMem,
  System.SysUtils,
  System.SyncObjs,
  Windows,
  inifiles,
  System.DateUtils,
  GlobalDefs in 'Data\GlobalDefs.pas',
  Log in 'Functions\Log.pas',
  Misc in 'Functions\Misc.pas',
  ServerSocket in 'Connection\ServerSocket.pas',
  Player in 'Functions\Player.pas',
  CryptLib in 'Connection\CryptLib.pas',
  Unknown in 'Functions\Unknown.pas',
  DBCon in 'Connection\DBCon.pas',
  Currencys in 'Functions\Currencys.pas',
  AccountInfo in 'Functions\AccountInfo.pas',
  Characters in 'Functions\Characters.pas',
  Inventory in 'Functions\Inventory.pas',
  Shop in 'Functions\Shop.pas',
  SortUS in 'Functions\SortUS.pas',
  Lobby in 'Functions\Lobby.pas',
  Nickname in 'Functions\Nickname.pas',
  Pets in 'Functions\Pets.pas',
  CHARID in 'Functions\CHARID.pas',
  Packets in 'Functions\Packets.pas',
  Azit in 'Functions\Azit.pas';

var
  Msg: TMsg;
  bRet: LongBool;
  UpTime: TDateTime;
  TimeInit: Integer;
  PortaMestre: integer;
  ini: TInifile;

begin
    ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'\config_server.ini');
  try
    PortaMestre:=ini.ReadInteger('GameServer','PortMaster',0);
    SetConsoleTitle('Game Server');
    MainCS:=TCriticalSection.Create;
    Randomize;
    UpTime:=Now;
    Logger:=TLog.Create;
    Logger.Write('Iniciando servidor',ServerStatus);
    try
      Server:=TServer.Create(PortaMestre);
      Writeln('Porta: ',PortaMestre);
      if Server.Socket.Active = True then begin
        TimeInit:=MilliSecondsBetween(Now, UpTime);
        Logger.Write('Servidor levou ' + IntToStr(TimeInit) + ' milisegundos para carregar(aprox: ' + FloatToStr(TimeInit/1000) +' segundos).', Warnings);
      end;
    except
      on E : Exception do
        Logger.Write(E.ClassName,Errors);
    end;
    while Server.Socket.Active do begin
      bRet:=GetMessage(Msg,0,0,0);
      if Integer(bRet) = -1 then begin
        Break;
      end
      else begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
