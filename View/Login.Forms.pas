unit Login.Forms;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.Buttons,
   Entities,
   Core.Interfaces,
   Core.Usuarios,
   Usuario.Forms;

type
   TfrmLogin = class(TForm)
      GroupBox1: TGroupBox;
      Label1: TLabel;
      Label2: TLabel;
      llbEsqueciSenha: TLinkLabel;
      edtEmail: TEdit;
      edtSenha: TEdit;
      btnAcessar: TBitBtn;
      chkExibirSenha: TCheckBox;
      llbCadastroUsuario: TLinkLabel;
      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure btnAcessarClick(Sender: TObject);
      procedure FormKeyPress(Sender: TObject; var Key: Char);
      procedure chkExibirSenhaClick(Sender: TObject);
      procedure llbCadastroUsuarioLinkClick(Sender: TObject; const Link: string;
        LinkType: TSysLinkType);
      procedure llbEsqueciSenhaLinkClick(Sender: TObject; const Link: string;
        LinkType: TSysLinkType);
   private
      FTentativas: Integer;
      FLogado: Boolean;
      FUsuario: TUsuario;
   public
      property Tentativas: Integer read FTentativas write FTentativas;
      property Logado: Boolean read FLogado write FLogado;
      property Usuario: TUsuario read FUsuario write FUsuario;

      procedure Logar;
   end;

var
   frmLogin: TfrmLogin;

implementation

{$R *.dfm}
{ TfrmLogin }

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
begin
   Logar;
end;

procedure TfrmLogin.chkExibirSenhaClick(Sender: TObject);
begin
   edtSenha.PasswordChar := '*';

   if chkExibirSenha.Checked then
      edtSenha.PasswordChar := #0;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if not Logado then
      Application.Terminate;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
   llbCadastroUsuario.Caption := '<a href="#">Cadastro de Usuário</a>';
   llbEsqueciSenha.Caption := '<a href="#">Esqueci Minha Senha</a>';
   Tentativas := 0;
   Logado := False;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
      Perform(WM_NEXTDLGCTL, 0, 0);
end;

procedure TfrmLogin.llbCadastroUsuarioLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
   if frmUsuarios = nil then
      frmUsuarios := TfrmUsuarios.Create(nil);
   try
      frmUsuarios.ShowModal;
   finally
      FreeAndNil(frmUsuarios);
   end;
end;

procedure TfrmLogin.llbEsqueciSenhaLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
var
   Engine: IUsuario;
   Email, Token: String;
begin
   Engine := TUsuarios.Create;
   Token := Engine.GetToken;
   Email := edtEmail.Text;
   try
      try
         if edtEmail.Text = EmptyStr then
         begin
            InputQuery('Esqueci minha senha', 'Informe o e-mail:', Email);
            //Engine.GerarEmail(Email);
         end;

         Engine.GerarEmail(Email);

         Application.MessageBox(Pchar(Format('E-mail enviado com sucesso para %s', [Email])),
              'Recuperação de Senha', 64);
      except
         on e: Exception do
            ShowMessage(e.Message);
      end;
   finally
      Engine := nil;
   end;
end;

procedure TfrmLogin.Logar;
var
   Engine: IUsuario;
begin
   try
      if Tentativas < 3 then
      begin
         Engine := TUsuarios.Create;
         Usuario := Engine.Logar(edtEmail.Text, edtSenha.Text);
         if Assigned(Usuario) then
         begin
            Logado := True;
            Close;
         end
         else
         begin
            Inc(FTentativas, 1);
            Application.MessageBox
              (PChar(Format('Login inválido. Tentativa: %d de 3.', [Tentativas])
              ), 'Login', 48);
         end;
      end
      else
         Application.Terminate;
   finally
      Engine := nil;
   end;
end;

end.
