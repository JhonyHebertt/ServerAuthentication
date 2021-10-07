unit uServerReactModelConnection;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.DApt,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL;


Var
  FConn :TFDConnection;

function Connected : TFDConnection;
procedure Disconnected;

implementation

function Connected : TFDConnection;
begin
 FConn:= TFDConnection.Create(nil);
 FConn.params.DriverID:='Mysql';
 {FConn.params.Database:='delphireact';
 FConn.params.UserName:='admin';
 FConn.params.Password:='admin777';
 FConn.params.Add('Port=3306');
 FConn.params.add('Server=delphireact.cm7ojuhyicsr.sa-east-1.rds.amazonaws.com');}

 FConn.params.Database:='dbReact';
 FConn.params.UserName:='root';
 FConn.params.Password:='';
 FConn.params.Add('Port=3306');
 FConn.params.add('localhost');

 FConn.Connected;

 Result:= FConn;
end;

procedure Disconnected;
begin
  if Assigned(FConn) then
  begin
    FConn.Connected:= False;
    fconn.Free;
  end;

end;

end.
