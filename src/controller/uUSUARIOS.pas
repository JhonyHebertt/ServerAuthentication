unit uUSUARIOS;

interface

uses
  Horse,
  BCrypt,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  JOSE.Types.JSON,
  SysUtils,
  System.JSON,
  uDAOGenerico,
  uUSUARIO;

procedure Registry(App : THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry(App : THorse);
begin
  App.Post('/usuarios/auth', Auth);
  App.Get('/usuarios', Get);
  App.Get('/usuarios/:id', GetID);
  App.Post('/usuarios', Insert);
  App.Put('/usuarios/:id', Update);
  App.Delete('/usuarios/:id', Delete);
end;

procedure Auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
  LToken : TJWT;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;

  FDAO
    .DAO
    .SQL
      .Where('USERNAME = ' + QuotedStr(Req.Body<TJsonObject>.GetValue<string>('USERNAME')))
    .&End
  .Find;

  try                    //senha informada no json                          //senha no banco
  if TBCrypt.CompareHash(Req.Body<TJsonObject>.GetValue<string>('PASSWORD'),FDAO.DataSet.FieldByName('PASSWORD').AsString) then
  begin
    LToken := TJWT.Create;
    try
      LToken.Claims.Issuer := 'ServerAuthentication'; //nome da aplicação
      LToken.Claims.Subject := FDAO.DataSet.FieldByName('USERNAME').AsString; //usuario que quer logar
      LToken.Claims.Expiration := Now + 1; //tempo de autenticação  (1 dia)

      Res.Status(200).Send<TJsonObject>(TJsonObject.Create.AddPair('token',TJOSE.SHA256CompactToken('DELPHIREACT',LToken)));
    finally
      LToken.Free;
    end;
  end
  else
    Res.Status(401);
  except
   Res.Status(500);
  end;
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
  LHash : String;
  aJsonUser : TJsonObject;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;
  aJsonUser := Req.Body<TJsonObject>;
  LHash := TBCrypt.GenerateHash(aJsonUser.GetValue<String>('PASSWORD'));
  aJsonUser.Get('PASSWORD').JsonValue := TJsonString.Create(LHash);
  Res.Send<TJSONObject>(FDAO.Insert(aJsonUser));
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;
  Res.Send<TJsonObject>(FDAO.Find(Req.Params.Items['id']));
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;
  Res.Send<TJsonArray>(FDAO.Find);
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;
  Res.Send<TJsonObject>(FDAO.Update(Req.Body<TJsonObject>));
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSUARIO>;
begin
  FDAO := TDAOGeneric<TUSUARIO>.New;
  Res.Send<TJsonObject>(FDAO.Delete('ID', Req.Params.Items['id']));
end;

end.
