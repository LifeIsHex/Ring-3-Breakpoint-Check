// Mahdi Hezaveh
// ring 3 bp detector
// https://github.com/LifeIsHex

unit ring_3_bp_detect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  Tbp_form = class(TForm)
    mmo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  bp_form: Tbp_form;

implementation

uses
  ring3detector;

{$R *.dfm}

procedure testBP();
var
  sign: string;
  tmp: Integer;
begin
  sign := 'find me in the debugger and set a BP here.';
  tmp := 0;
  tmp := tmp + 1;
  tmp := tmp + 1;
end;

procedure Tbp_form.FormCreate(Sender: TObject);
begin
  // sample 1: single check
  if isBPPresent(@testBP) then
    mmo1.Lines.Add('There is a breakpoint detected in the testBP(); procedure.');

  // sample 2: all import check
  // Look at the ring3detector.pas, executed with CreateThread
end;

end.

