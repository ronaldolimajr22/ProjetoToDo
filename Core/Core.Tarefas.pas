unit Core.Tarefas;

interface

uses
   System.SysUtils,
   System.Classes,
   System.Generics.Collections,
   Entities,
   Aurelius.Engine.ObjectManager,
   Aurelius.Criteria.Linq,
   Aurelius.Criteria.Base,
   ConnectionModule,
   Core.Interfaces,
   Core.Usuarios,
   RestAPI.DTO.Response,
   Core.Funcional.HTTP.Rest;

type
   TTarefas = class(TInterfacedObject, IPersistencia<TTarefa>, ITarefas)
   private
      function ListarTodos(const aStatus: Boolean): TObjectList<TTarefa>;
   public
      function Salvar(aObjeto: TTarefa): Integer;
      function Excluir(aObjeto: TTarefa): Boolean;
      function Listar(const aTitulo: String; const aStatus: Boolean)
        : TObjectList<TTarefa>;

      procedure GerarEmailTarefa(aIdTarefa: Integer;
        aDataTarefa: TDateTime; aDescricaoTarefa, aUsuarioEmail, aUsuarioNome: String);
   end;

implementation

{ TTarefas }

function TTarefas.Excluir(aObjeto: TTarefa): Boolean;
var
   Manager: TObjectManager;
   Tarefa: TTarefa;
begin
   Result := False;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   try
      try
         Tarefa := Manager.Find<TTarefa>(aObjeto.Id);
         if Assigned(Tarefa) then
         begin
            Manager.Remove(Tarefa);
            Result := True;
         end;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

procedure TTarefas.GerarEmailTarefa(aIdTarefa: Integer;
  aDataTarefa: TDateTime; aDescricaoTarefa, aUsuarioEmail, aUsuarioNome: String);
const
   CJSON: String = '{ ' + '"fromEmail": "%s", ' + '"fromName": "%s", ' +
     '"subject": "%s", ' + '"message": "%s", ' + '"to": "%s" ' + '}';
var
   Token, JSon, Mensagem: String;
   // Manager: TObjectManager;
   Response: TRestResultDTO;
   Engine: TUsuarios;
begin
   // Manager := nil;
   try
      try
         Mensagem :=
           Format('Ol?, <b>%s</b>. </br> '+
           'A tarefa <b>%d</b> foi conclu?da veja alguns detalhes:</br> '+
           '- Data da conclus?o: <b>%s</b></br> '+
           '- Descri??o da tarefa: <b>%s</b>',
           [aUsuarioNome, aIdTarefa, DateToStr(aDataTarefa), aDescricaoTarefa]);

         Engine := TUsuarios.Create;
         Token := Engine.GetToken;

         JSon := Format(CJSON, ['mensageiro@racsystems.com.br', 'Projeto ToDo',
           Format('Projeto ToDo - Tarefa %d Conclu?da', [aIdTarefa]), Mensagem,
           aUsuarioEmail]);

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
      Engine := nil;

      if Assigned(Response) then
         FreeAndNil(Response);
   end;
end;

function TTarefas.Listar(const aTitulo: String; const aStatus: Boolean)
  : TObjectList<TTarefa>;
var
   Manager: TObjectManager;
   Criteria: TCriteria<TTarefa>;
   Filter: TCustomCriterion;
begin
   Result := nil;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   Manager.OwnsObjects := False;
   try
      try
         Criteria := Manager.Find<TTarefa>;
         if not aTitulo.IsEmpty then
         begin
            Filter := Linq.Contains('TITULO', aTitulo.Trim);
            Criteria.Add(Filter);
         end;

         Filter := Linq.Eq('CONCLUIDO', aStatus);
         Criteria.Add(Filter);

         Result := Criteria.List;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

function TTarefas.ListarTodos(const aStatus: Boolean): TObjectList<TTarefa>;
begin
   Result := nil;
end;

function TTarefas.Salvar(aObjeto: TTarefa): Integer;
var
   Manager: TObjectManager;
   NewObject: TTarefa;

   procedure Preencher;
   begin
      NewObject.Titulo := aObjeto.Titulo;
      NewObject.Descricao := aObjeto.Descricao;
      NewObject.Concluido := aObjeto.Concluido;
      NewObject.Data := aObjeto.Data;
   end;

begin
   Result := 0;
   Manager := TObjectManager.Create
     (FireDacFirebird3Connection.CreateConnection);
   try
      try
         if aObjeto.Id > 0 then
         begin
            NewObject := Manager.Find<TTarefa>(aObjeto.Id);
            if Assigned(NewObject) then
            begin
               Preencher;
               Manager.Flush(NewObject);
            end;
         end
         else
         begin
            NewObject := TTarefa.Create;
            Preencher;
            NewObject.Usuario := Manager.Find<TUsuario>(aObjeto.Usuario.Id);
            Manager.Save(NewObject);
         end;

         Result := NewObject.Id;
      except
         raise;
      end;
   finally
      Manager.Free;
   end;
end;

end.
