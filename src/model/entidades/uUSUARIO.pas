unit uUSUARIO;

interface

uses
  SimpleAttributes;

type
  [Tabela('usuarios')]
  TUSUARIO = class
    private
    FID: Integer;
    FSTATUS: Integer;
    FPASSWORD: String;
    FUSERNAME: String;
    procedure SetID(const Value: Integer);
    procedure SetPASSWORD(const Value: String);
    procedure SetSTATUS(const Value: Integer);
    procedure SetUSERNAME(const Value: String);
    public
      constructor Create;
      destructor Destroy; override;
    published
      [Campo('ID'), Pk, AutoInc]
      property ID : Integer read FID write SetID;
      [Campo('USERNAME')]
      property USERNAME : String read FUSERNAME write SetUSERNAME;
      [Campo('PASSWORD')]
      property PASSWORD : String read FPASSWORD write SetPASSWORD;
      [Campo('STATUS')]
      property STATUS : Integer read FSTATUS write SetSTATUS;
  end;


implementation

{ TUSUARIO }

constructor TUSUARIO.Create;
begin

end;

destructor TUSUARIO.Destroy;
begin

  inherited;
end;

procedure TUSUARIO.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TUSUARIO.SetPASSWORD(const Value: String);
begin
  FPASSWORD := Value;
end;

procedure TUSUARIO.SetSTATUS(const Value: Integer);
begin
  FSTATUS := Value;
end;

procedure TUSUARIO.SetUSERNAME(const Value: String);
begin
  FUSERNAME := Value;
end;

end.
