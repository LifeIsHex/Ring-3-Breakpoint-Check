program prj_ring_3_bp_detect;

uses
  Vcl.Forms,
  ring_3_bp_detect in 'ring_3_bp_detect.pas' {bp_form};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tbp_form, bp_form);
  Application.Run;
end.
