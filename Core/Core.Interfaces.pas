unit Core.Interfaces;

interface
uses
   System.Classes,
   System.Generics.Collections,
   Entities,
   Core.Funcional.HTTP.Rest,
   RestAPI.DTO.Response;

type
   IPersistencia<T: class>= interface
      ['{34688D4E-C477-43D9-89BD-B78DC9E0631F}']

      function Salvar(aObjeto: T): Integer; overload;
      function Excluir(aObjeto: T): Boolean;
      function ListarTodos(const aStatus: Boolean): TObjectList<T>;
   end;

   IUsuario = interface
      ['{D8664C93-16B5-4213-BF2B-188E5C633A46}']
      function Logar(const aEmail, aSenha: String): TUsuario;
      function GetToken: String;
      procedure GerarEmail(aUsuario: String);

   end;

   ITarefas = interface
      ['{9E402576-7B4C-4BE4-9932-4DFEAC302757}']
      function Listar(const aTitulo: String; const aStatus: Boolean): TObjectList<TTarefa>;
      procedure GerarEmailTarefa(aIdTarefa: Integer; aDataTarefa: TDateTime; aDescricaoTarefa, aUsuarioEmail, aUsuarioNome: String);
   end;

implementation

end.
