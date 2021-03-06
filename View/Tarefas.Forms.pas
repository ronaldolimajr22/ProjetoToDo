unit Tarefas.Forms;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.StrUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.ComCtrls,
   Vcl.StdCtrls,
   Data.DB,
   Vcl.Grids,
   Vcl.DBGrids,
   Vcl.Buttons,
   Vcl.ExtCtrls,
   Aurelius.Bind.BaseDataset,
   Aurelius.Bind.Dataset,
   Login.Forms, Core.Interfaces, Entities, Core.Tarefas,
   System.Generics.Collections;

type
   TfrmTarefas = class(TForm)
      pgPrincipal: TPageControl;
      tsPesquisa: TTabSheet;
      tsDados: TTabSheet;
      grpPesquisa: TGroupBox;
      StatusBar: TStatusBar;
      pnlDadosBotoes: TPanel;
      btnSalvar: TBitBtn;
      btnCancelar: TBitBtn;
      grpAtividades: TGroupBox;
      lblTitulo: TLabel;
      lblDescricao: TLabel;
      edtTitulo: TEdit;
      mmoDescricao: TMemo;
      chkConcluida: TCheckBox;
      chkExibirConcluido: TCheckBox;
      pnlPesquisa: TPanel;
      grbPesquisa: TDBGrid;
      cdsPesquisa: TAureliusDataset;
      dsPesquisa: TDataSource;
      btnEditar: TSpeedButton;
      btnExcluir: TSpeedButton;
      btnNovo: TSpeedButton;
      lblPTitulo: TLabel;
      edtPTitulo: TEdit;
      btnPesquisar: TButton;
      cdsPesquisaTitulo: TStringField;
      cdsPesquisaConcluido: TBooleanField;
      cdsPesquisaData: TDateTimeField;
      procedure FormCreate(Sender: TObject);
      procedure btnSalvarClick(Sender: TObject);
      procedure btnNovoClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure grbPesquisaCellClick(Column: TColumn);
      procedure grbPesquisaDblClick(Sender: TObject);
      procedure btnPesquisarClick(Sender: TObject);
      procedure btnExcluirClick(Sender: TObject);
      procedure btnEditarClick(Sender: TObject);
   private
      FUsuarioLogado: TUsuario;
      FRegistroAlterado: Boolean;
      FTarefas: TObjectList<TTarefa>;
      FId: Integer;
      FTarefa: TTarefa;
      FItem: TTarefa;

      procedure Limpar;
      procedure Gravar;
      procedure Pesquisar;
      procedure VisualizarRegistro;
      procedure Excluir;
   public
      property UsuarioLogado: TUsuario read FUsuarioLogado write FUsuarioLogado;
      property Tarefa: TTarefa read FTarefa write FTarefa;
      property Item: TTarefa read FItem write FItem;
   published
      procedure RegistroAlterado;
   end;

var
   frmTarefas: TfrmTarefas;

implementation

{$R *.dfm}

procedure TfrmTarefas.btnEditarClick(Sender: TObject);
begin
   VisualizarRegistro;
end;

procedure TfrmTarefas.btnExcluirClick(Sender: TObject);
begin
   Excluir;
end;

procedure TfrmTarefas.btnNovoClick(Sender: TObject);
begin
   pgPrincipal.ActivePage := tsDados;
   edtTitulo.SetFocus;
   FId := 0;
end;

procedure TfrmTarefas.btnPesquisarClick(Sender: TObject);
begin
   Pesquisar;
end;

procedure TfrmTarefas.btnSalvarClick(Sender: TObject);
begin
   Gravar;
end;

procedure TfrmTarefas.Excluir;
const
   CPERGUNTA: String = 'Deseja realmente excluir esta tarefa [%s]?';
   CSUCESSO: String = 'Opera??o realizada com sucesso';
   CERRO: String = 'Ocorreu um erro ao excluir a tarefa: [%s]';
var
   Tarefa: TTarefa;
   Engine: IPersistencia<TTarefa>;
begin
   if cdsPesquisa.IsEmpty then
      Exit;

   Tarefa := cdsPesquisa.Current<TTarefa>;

   if not Assigned(Tarefa) then
      Exit;

   if Application.MessageBox(Pchar(Format(CPERGUNTA, [Tarefa.Titulo])),
     'Excluir - Tarefa', 36) = mrNo then
      Exit;
   try
      try
         Engine := TTarefas.Create;
         if Engine.Excluir(Tarefa) then
         begin
            cdsPesquisa.Delete;
            Application.MessageBox(Pchar(CSUCESSO), 'Excluir - Tarefas', 64);
         end;
      except
         on e: Exception do
            Application.MessageBox(Pchar(Format(CERRO, [e.Message])),
              'Excluir - Tarefas', 16);
      end;
   finally
      Engine := nil;
   end;
end;

procedure TfrmTarefas.FormCreate(Sender: TObject);
begin
   if frmLogin = nil then
      frmLogin := TfrmLogin.Create(nil);
   try
      try
         frmLogin.ShowModal;
         UsuarioLogado := frmLogin.Usuario;
         if Assigned(UsuarioLogado) then
            StatusBar.Panels[1].Text := UsuarioLogado.Nome;
      except
         on e: Exception do
            ShowMessage(e.Message);
      end;
   finally
      FreeAndNil(frmLogin);
   end;

   pgPrincipal.ActivePage := tsPesquisa;
   btnEditar.Enabled := False;
   btnExcluir.Enabled := False;
   FId := 0;
end;

procedure TfrmTarefas.FormDestroy(Sender: TObject);
var
   Item: TTarefa;
   i: Integer;
begin
   if Assigned(UsuarioLogado) then
      FreeAndNil(FUsuarioLogado);

   i := 0;
   if Assigned(FTarefas) then
   begin
      for Item in FTarefas do
      begin
         if i = 0 then
         begin
            if Assigned(Item.Usuario) then
               Item.Usuario.Free;

            i := i + 1;
         end;
         Item.Free;
      end;
   end;
end;

procedure TfrmTarefas.Gravar;
var
   Engine: IPersistencia<TTarefa>;
   Engine2: TTarefas;
   Objeto: TTarefa;
   id: Integer;
begin
   try
      try
         Objeto := TTarefa.Create;
         Objeto.id := FId;
         Objeto.Titulo := Trim(edtTitulo.Text);
         Objeto.Descricao := Trim(mmoDescricao.Text);
         Objeto.Concluido := chkConcluida.Checked;
         Objeto.Data := Now;
         Objeto.Usuario := UsuarioLogado;
         Engine := TTarefas.Create;
         id := Engine.Salvar(Objeto);
         if (FId > 0) or (chkConcluida.Checked) then
         begin
            Engine2 := TTarefas.Create;
            Engine2.GerarEmailTarefa
            (Objeto.Id, Objeto.Data, Objeto.Descricao, UsuarioLogado.Email, UsuarioLogado.Nome);
            Engine2 := nil;
         end;
         if id > 0 then
            Application.MessageBox('Opera??o realizada com sucesso',
              'Salvar', 64);
      except
         on e: Exception do
            Application.MessageBox(Pchar(Format('Falha na opera??o: %s',
              [e.Message])), 'Erro', 16);
      end;
   finally
      Engine := nil;
      Limpar;

      if Assigned(Objeto) then
         FreeAndNil(Objeto);
//
//      if FId > 0 then
//      begin
//         Pesquisar;
//         pgPrincipal.ActivePage := tsPesquisa;
//      end;
   end;
end;

procedure TfrmTarefas.grbPesquisaCellClick(Column: TColumn);
begin
   btnExcluir.Enabled := True;
   btnEditar.Enabled := True;
end;

procedure TfrmTarefas.grbPesquisaDblClick(Sender: TObject);
begin
   VisualizarRegistro;
end;

procedure TfrmTarefas.Limpar;
begin
   edtTitulo.Clear;
   mmoDescricao.Clear;
   chkConcluida.Checked := False;
end;

procedure TfrmTarefas.Pesquisar;
var
   Engine: ITarefas;
   Item: TTarefa;
   i: Integer;
begin
   try
      i := 0;
      if Assigned(FTarefas) then
      begin
         for Item in FTarefas do
         begin
            if i = 0 then
            begin
               if Assigned(Item.Usuario) then
                  Item.Usuario.Free;

               i := i + 1;
            end;
            Item.Free;
         end;
         FreeAndNil(FTarefas);
      end;

      Engine := TTarefas.Create;
      FTarefas := Engine.Listar(edtPTitulo.Text, chkExibirConcluido.Checked);
      if Assigned(FTarefas) then
      begin
         if cdsPesquisa.Active then
            cdsPesquisa.Close;

         cdsPesquisa.SetSourceList(FTarefas);
         cdsPesquisa.Open;
      end;

      Engine := nil;
   except
      on e: Exception do
         Application.MessageBox(Pchar(Format('Falha na pesquisa: %s',
           [e.Message])), 'Erro na Pesquisa', 16);
   end;
end;

procedure TfrmTarefas.RegistroAlterado;
begin
   FRegistroAlterado := True;
end;

procedure TfrmTarefas.VisualizarRegistro;
begin
   if cdsPesquisa.IsEmpty then
      Exit;

   Tarefa := cdsPesquisa.Current<TTarefa>;
   if Assigned(Tarefa) then
   begin
      pgPrincipal.ActivePage := tsDados;
      FId := Tarefa.id;
      edtTitulo.Text := Tarefa.Titulo;
      mmoDescricao.Text := Tarefa.Descricao;
      chkConcluida.Checked := Tarefa.Concluido;
   end;
end;

end.
