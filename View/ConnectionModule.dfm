object FireDacFirebird3Connection: TFireDacFirebird3Connection
  OldCreateOrder = True
  Height = 198
  Width = 282
  object Connection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Ronaldo\Documents\AulaDelphi\Projeto ToDo\db\b' +
        'anco.fdb'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=23062'
      'DriverID=FB')
    LoginPrompt = False
    Left = 64
    Top = 8
  end
  object AureliusConnection: TAureliusConnection
    AdapterName = 'FireDac'
    AdaptedConnection = Connection
    SQLDialect = 'Firebird3'
    Left = 64
    Top = 64
  end
end
