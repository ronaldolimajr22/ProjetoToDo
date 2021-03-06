unit Core.Usuarios;

interface

uses
   System.Classes,
   System.Generics.Collections,
   Entities,
   Aurelius.Engine.ObjectManager,
   Aurelius.Criteria.Linq,
   ConnectionModule,
   Core.Interfaces,
   RestAPI.DTO.Response,
   Core.Funcional.HTTP.Rest,
   System.SysUtils,
   System.JSon,
   Rest.JSon,
   Core.DTO.Utils;

type
   TUsuarios = class(TInterfacedObject, IPersistencia<TUsuario>, IUsuario)
   private
   public
      function Salvar(aObjeto: TUsuario): Integer;
      function Excluir(aObjeto: TUsuario): Boolean;
      function ListarTodos(const aStatus: Boolean): TObjectList<TUsuario>;
      function Logar(const aEmail, aSenha: String): TUsuario;
      function GetToken: String;
      procedure GerarEmail(aUsuario: String);
   end;

implementation

{ TUsuarios }

function TUsuarios.Excluir(aObjeto: TUsuario): Boolean;
var
   Manager: TObjectManager;
begin
   Result := True;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   try
      try
         Manager.Remove(aObjeto);
      except
         raise;
      end;
   finally
      Manager.Free;
      Result := False;
   end;
end;

procedure TUsuarios.GerarEmail(aUsuario: String);
const
   CJSON: String = '{ ' + '"fromEmail": "%s", ' + '"fromName": "%s", ' +
     '"subject": "%s", ' + '"message": "%s", ' + '"to": "%s" ' + '}';
var
   Token, JSon, Mensagem: String;
   Manager: TObjectManager;
   Usuario: TUsuario;
   Response: TRestResultDTO;
begin
   Manager := nil;
   try
      try
         Manager := TObjectManager.Create
           (FireDacFirebird3Connection.CreateConnection);
         Usuario := Manager.Find<TUsuario>.Add(Linq.Eq('Email', aUsuario))
           .UniqueResult;

         if not Assigned(Usuario) then
            raise Exception.Create('Usu?rio n?o encontrado');

         Mensagem := Format('Sua senha de acesso ?: %s', [Usuario.Senha]);
         Token := GetToken;

         JSon := Format(CJSON, ['mensageiro@racsystems.com.br', 'Projeto ToDo',
           'Projeto ToDo - Recupera??o de Senha', Mensagem, aUsuario]);
           
         Response := TRestFuncional.New.Url
           ('https://alfred-email.racsys.com.br/')
           .ContentType('application/json').AddAuthorization(Token, atBearer)
           .AddBody(JSon, btJson).Post;

         if (not Assigned(Response)) or (Response.StatusCode <> 201) then
            raise Exception.Create('Falha ao enviar email');

      except
         raise;
      end;
   finally
      Manager.Free;

      if Assigned(Response) then
         FreeAndNil(Response);
   end;
end;

function TUsuarios.GetToken: String;
const
   CJSON: String = '{"product": "Todo", "param": "d", "value": 10 }';
var
   Response: TRestResultDTO;
   jv: TJSONValue;
   jsonObj: TJSONObject;
   // Token: TToken;
begin
   try
      try
         Response := TRestFuncional.New.Url
           ('https://alfred-token.racsys.com.br/')
           .ContentType('application/json').AddBody(CJSON, btJson).Post;

         jsonObj := TJSONObject.ParseJSONValue(Response.Data) as TJSONObject;
         jv := jsonObj.Get('token').JsonValue;

         Result := jv.Value;

         // Token := TToken.Create;
         // Token := TJson.JsonToObject<TToken>(Response.ToString, [joIgnoreEmptyStrings]);
         //
         // Result := Token.token;
      except
         raise;
      end;
   finally
      if Assigned(Response) then
         FreeAndNil(Response);

      if Assigned(jsonObj) then
         FreeAndNil(jsonObj);
   end;
end;

function TUsuarios.ListarTodos(const aStatus: Boolean): TObjectList<TUsuario>;
var
   Manager: TObjectManager;
begin
   Result := nil;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   Manager.OwnsObjects := False;
   try
      try
         Result := Manager.Find<TUsuario> //
           .Add(Linq.Eq('STATUS', aStatus)) //
           .List;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

function TUsuarios.Logar(const aEmail, aSenha: String): TUsuario;
var
   Manager: TObjectManager;
begin
   Result := nil;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   Manager.OwnsObjects := False;
   try
      try
         Result := Manager.Find<TUsuario> //
           .Add(Linq.Eq('EMAIL', aEmail)) //
           .Add(Linq.Eq('SENHA', aSenha)) //
           .Add(Linq.Eq('STATUS', True)) //
           .UniqueResult;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

function TUsuarios.Salvar(aObjeto: TUsuario): Integer;
var
   Manager: TObjectManager;
   NewObject: TUsuario;
begin
   Result := 0;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   try
      try
         if aObjeto.Id > 0 then
         begin
            NewObject := Manager.Find<TUsuario>(aObjeto.Id);
            if Assigned(NewObject) then
            begin
               NewObject.Nome := aObjeto.Nome;
               NewObject.Email := aObjeto.Email;
               NewObject.Senha := aObjeto.Senha;
               Manager.Flush(NewObject);
            end;
         end
         else
            Manager.Save(aObjeto);

         Result := aObjeto.Id;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

end.
