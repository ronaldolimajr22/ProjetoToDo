unit Entities;

interface

uses
   Aurelius.Mapping.Attributes,
   Aurelius.Types.Blob,
   Aurelius.Types.Nullable;

type
   TUsuario = class;
   TTarefa = class;

   [Entity]
   [Table('TUSUARIO')]
   [Sequence('GEN_TUSUARIO_ID')]
   [Id('FId', TIdGenerator.IdentityOrSequence)]
   TUsuario = class
   private
      [Column('ID', [TColumnProp.Unique, TColumnProp.Required,
        TColumnProp.NoUpdate])]
      FId: Integer;

      [Column('NOME', [TColumnProp.Required], 100)]
      FNome: String;

      [Column('EMAIL', [TColumnProp.Required], 100)]
      FEmail: String;

      [Column('SENHA', [TColumnProp.Required], 100)]
      FSenha: String;

      [Column('STATUS', [TColumnProp.Required])]
      FStatus: Boolean;
   public
      property Id: Integer read FId write FId;
      property Nome: String read FNome write FNome;
      property Email: String read FEmail write FEmail;
      property Senha: String read FSenha write FSenha;
      property Status: Boolean read FStatus write FStatus;
   end;

   [Entity]
   [Table('TTAREFA')]
   [Sequence('GEN_TTAREFA_ID')]
   [Id('FId', TIdGenerator.IdentityOrSequence)]
   TTarefa = class
   private
      [Column('ID', [TColumnProp.Unique, TColumnProp.Required,
        TColumnProp.NoUpdate])]
      FId: Integer;

      [Column('TITULO', [TColumnProp.Required], 100)]
      FTitulo: String;

      [Column('DESCRICAO', [TColumnProp.Required], 1024)]
      FDescricao: String;

      [Column('CONCLUIDO', [TColumnProp.Required])]
      FConcluido: Boolean;

      [Column('DATA', [TColumnProp.Required])]
      FData: TDateTime;

      [Association([TAssociationProp.Required], [TCascadeType.Flush])]
      [JoinColumn('USUARIO_ID', [TColumnProp.Required], 'ID')]
      FUsuario: TUsuario;
   public
      property Id: Integer read FId write FId;
      property Titulo: String read FTitulo write FTitulo;
      property Descricao: String read FDescricao write FDescricao;
      property Concluido: Boolean read FConcluido write FConcluido;
      property Data: TDateTime read FData write FData;
      property Usuario: TUsuario read FUsuario write FUsuario;
   end;

implementation

initialization

RegisterEntity(TUsuario);
RegisterEntity(TTarefa);

end.
