object frmLogin: TfrmLogin
  Left = 0
  Top = 15
  BorderStyle = bsDialog
  Caption = 'Projeto ToDo - Login'
  ClientHeight = 174
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 284
    Height = 164
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = 'Informa'#231#245'es de Login'
    TabOrder = 0
    object Label1: TLabel
      Left = 34
      Top = 35
      Width = 32
      Height = 13
      Caption = 'E-mail:'
    end
    object Label2: TLabel
      Left = 32
      Top = 72
      Width = 34
      Height = 13
      Caption = 'Senha:'
    end
    object llbEsqueciSenha: TLinkLabel
      Left = 138
      Top = 122
      Width = 103
      Height = 17
      Cursor = crHandPoint
      Caption = 'Esqueci minha senha'
      TabOrder = 3
      OnLinkClick = llbEsqueciSenhaLinkClick
    end
    object edtEmail: TEdit
      Left = 72
      Top = 32
      Width = 169
      Height = 21
      TabOrder = 0
    end
    object edtSenha: TEdit
      Left = 72
      Top = 69
      Width = 169
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object btnAcessar: TBitBtn
      Left = 138
      Top = 96
      Width = 103
      Height = 25
      Caption = 'Acessar'
      TabOrder = 2
      OnClick = btnAcessarClick
    end
    object chkExibirSenha: TCheckBox
      Left = 34
      Top = 104
      Width = 81
      Height = 17
      Caption = 'Exibir Senha'
      TabOrder = 4
      OnClick = chkExibirSenhaClick
    end
    object llbCadastroUsuario: TLinkLabel
      Left = 138
      Top = 136
      Width = 102
      Height = 17
      Caption = 'Cadastro de Usu'#225'rio'
      TabOrder = 5
      OnLinkClick = llbCadastroUsuarioLinkClick
    end
  end
end
