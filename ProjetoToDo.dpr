program ProjetoToDo;

uses
  Vcl.Forms,
  Login.Forms in 'View\Login.Forms.pas' {frmLogin},
  Tarefas.Forms in 'View\Tarefas.Forms.pas' {frmTarefas},
  Entities in 'Entities\Entities.pas',
  Core.Interfaces in 'Core\Core.Interfaces.pas',
  Core.Usuarios in 'Core\Core.Usuarios.pas',
  Core.Tarefas in 'Core\Core.Tarefas.pas',
  ConnectionModule in 'View\ConnectionModule.pas' {FireDacFirebird3Connection: TDataModule},
  Usuario.Forms in 'View\Usuario.Forms.pas' {frmUsuarios},
  Core.Funcional.HTTP.Rest in 'C:\#trabalho\Dev\Core\DTO_Util\Core.Funcional.HTTP.Rest.pas',
  RestAPI.DTO.Response in 'C:\#trabalho\Dev\Core\DTO_Util\RestAPI.DTO.Response.pas',
  Core.DTO.Utils in 'Core\Core.DTO.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFireDacFirebird3Connection, FireDacFirebird3Connection);
  Application.CreateForm(TfrmTarefas, frmTarefas);
  Application.Run;
end.
