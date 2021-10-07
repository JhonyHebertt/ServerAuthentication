program ServerAuthentication;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  uServerReactModelConnection in 'src\model\uServerReactModelConnection.pas',
  uUsuarios in 'src\controller\uUsuarios.pas',
  uUsuario in 'src\model\entidades\uUsuario.pas',
  uDAOGenerico in 'src\model\uDAOGenerico.pas';

Var
  App: THorse;
begin

  try
    if THorse.IsRunning then
      THorse.StopListen;
    App := THorse.Create(9005);
  except
    THorse.StopListen;
  end;

  App.Use(Jhonson);
  App.Use(CORS);
  //Controller de Entidades
  uUsuarios.Registry(App);

  App.Start;
end.
