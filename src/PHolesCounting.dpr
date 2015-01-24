program PHolesCounting;

uses
  Forms,
  UFMain in 'UFMain.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
