object frmUsuarios: TfrmUsuarios
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'TODO - Usu'#225'rios'
  ClientHeight = 206
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox: TGroupBox
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 332
    Height = 155
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = 'Dados do Usu'#225'rio'
    TabOrder = 0
    object lblNome: TLabel
      Left = 16
      Top = 32
      Width = 31
      Height = 13
      Caption = 'Nome:'
    end
    object lblEmail: TLabel
      Left = 15
      Top = 59
      Width = 32
      Height = 13
      Caption = 'E-mail:'
    end
    object lblSenha: TLabel
      Left = 13
      Top = 86
      Width = 34
      Height = 13
      Caption = 'Senha:'
    end
    object edtNome: TEdit
      Left = 53
      Top = 29
      Width = 252
      Height = 21
      BevelEdges = [beLeft, beTop, beRight]
      TabOrder = 0
    end
    object edtEmail: TEdit
      Left = 53
      Top = 56
      Width = 252
      Height = 21
      BevelEdges = [beLeft, beTop, beRight]
      TabOrder = 1
    end
    object edtSenha: TEdit
      Left = 53
      Top = 83
      Width = 252
      Height = 21
      BevelEdges = [beLeft, beTop, beRight]
      PasswordChar = '*'
      TabOrder = 2
    end
    object chkExibirSenha: TCheckBox
      Left = 53
      Top = 110
      Width = 97
      Height = 17
      Caption = 'Exibir Senha'
      TabOrder = 3
      OnClick = chkExibirSenhaClick
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 165
    Width = 342
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancelar: TBitBtn
      AlignWithMargins = True
      Left = 153
      Top = 3
      Width = 90
      Height = 35
      Align = alRight
      Caption = 'Cancelar'
      TabOrder = 0
      OnClick = btnCancelarClick
    end
    object btnSalvar: TBitBtn
      AlignWithMargins = True
      Left = 249
      Top = 3
      Width = 90
      Height = 35
      Align = alRight
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = btnSalvarClick
    end
  end
end
