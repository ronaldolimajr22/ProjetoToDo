unit ConnectionModule;

interface

uses
  Aurelius.Drivers.Interfaces,
  Aurelius.Drivers.FireDac,  
  FireDAC.Dapt,
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Aurelius.Sql.Firebird3,
  Aurelius.Schema.Firebird3, Aurelius.Comp.Connection, Data.DB,
  FireDAC.Comp.Client;

type
  TFireDacFirebird3Connection = class(TDataModule)
    Connection: TFDConnection;
    AureliusConnection: TAureliusConnection;
  private
  public
    class function CreateConnection: IDBConnection;
    class function CreateFactory: IDBConnectionFactory;
    
  end;

var
  FireDacFirebird3Connection: TFireDacFirebird3Connection;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses 
  Aurelius.Drivers.Base;

{$R *.dfm}

{ TMyConnectionModule }

class function TFireDacFirebird3Connection.CreateConnection: IDBConnection;
begin 
  Result := FireDacFirebird3Connection.AureliusConnection.CreateConnection;
end;

class function TFireDacFirebird3Connection.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection;
    end
  );
end;



end.
