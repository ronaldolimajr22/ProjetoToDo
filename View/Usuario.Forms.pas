unit Usuario.Forms;

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
   Vcl.StdCtrls,
   Vcl.Buttons,
   Vcl.ExtCtrls,
   Core.Interfaces,
   Core.Usuarios,
   Entities;

type
   TfrmUsuarios = class(TForm)
      GroupBox: TGroupBox;
      pnlBotoes: TPanel;
      lblNome: TLabel;
      lblEmail: TLabel;
      lblSenha: TLabel;
      edtNome: TEdit;
      edtEmail: TEdit;
      edtSenha: TEdit;
      btnCancelar: TBitBtn;
      btnSalvar: TBitBtn;
      chkExibirSenha: TCheckBox;
      procedure chkExibirSenhaClick(Sender: TObject);
      procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   private
      procedure Salvar;
      procedure Limpar;
   public

   end;

var
   frmUsuarios: TfrmUsuarios;

implementation

{$R *.dfm}

procedure TfrmUsuarios.btnCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmUsuarios.btnSalvarClick(Sender: TObject);
begin
   Salvar;
end;

procedure TfrmUsuarios.chkExibirSenhaClick(Sender: TObject);
begin
   edtSenha.PasswordChar := '*';

   if chkExibirSenha.Checked then
      edtSenha.PasswordChar := #0;
end;

procedure TfrmUsuarios.Limpar;
begin
   edtNome.Clear;
   edtEmail.Clear;
   edtSenha.Clear;
end;

procedure TfrmUsuarios.Salvar;
var
   Engine: IPersistencia<TUsuario>;
   Usuario: TUsuario;
begin
   try
      try
         Usuario := TUsuario.Create;
         Usuario.Nome := Trim(UpperCase(edtNome.Text));
         Usuario.Email := Trim(edtEmail.Text);
         Usuario.Senha := Trim(edtSenha.Text);
         Usuario.Status := True;
         Engine := TUsuarios.Create;
         Engine.Salvar(Usuario);
         Application.MessageBox('Opera??o realizada com sucesso',
              'Salvar', 64);
      except
         on e: Exception do
            Application.MessageBox(Pchar(Format('Ocorreu um erro ao salvar o usuario: %s', [e.Message])), 'Salvar', 16);
      end;
   finally
      Engine := nil;
   end;
end;

end.
