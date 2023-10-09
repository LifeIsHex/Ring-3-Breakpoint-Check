// Mahdi Hezaveh
// ring 3 bp detector
// https://github.com/LifeIsHex

unit ring3detector;

interface

uses
  Winapi.Windows;

function isBPPresent(Address: Pointer): Boolean;

implementation

//==============================================================================

const
  WaitTimeForCheckBPAPI = 60 * 1000;

type
  PIMAGE_IMPORT_DESCRIPTOR = ^TIMAGE_IMPORT_DESCRIPTOR;

  TIMAGE_IMPORT_DESCRIPTOR = packed record
    OriginalFirstThunk: DWORD;
    TimeDateStamp: DWORD;
    ForwarderChain: DWORD;
    Name: DWORD;
    FirstThunk: DWORD;
  end;

//==============================================================================

function isBPPresent(Address: Pointer): Boolean;
var
  rByte: PByte;
begin
  rByte := Address;
  if Address <> NIL then
  begin
    if (PDWORD64(Address)^ - $25FF) = 0 then
    {$ifdef WIN32}
    rByte := PPointer(PPointer(Pointer(DWORD(Address) + 2))^)^;
    {$else}
    rByte := PPointer(PPointer(Pointer(DWORD64(Address) + 2))^)^;
    {$endif}

    if (rByte <> NIL) and (rByte^ = $CC) then
      Result := True
    else
      Result := False
  end;
end;

//==============================================================================

function CheckAllImportForBP: Integer; stdcall;
var
  SecBaseAdr: SIZE_T;
  NTHead: PImageNtHeaders;
  ImportPoint: PIMAGE_IMPORT_DESCRIPTOR;
  P: PByte;
  {$ifdef WIN32}
  PD: PDWORD;
  {$else}
  PD: PDWORD64;
  {$endif}
begin

  Result := NO_ERROR;
  SecBaseAdr := GetModuleHandle(NIL);
  NTHead := Pointer(DWORD(PImageDosHeader(SecBaseAdr)._lfanew) + SecBaseAdr);
  ImportPoint := Pointer(NTHead^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress + SecBaseAdr);

  while ImportPoint^.FirstThunk <> 0 do
  begin
    {$ifdef WIN32}
    PD := PDWORD(ImportPoint.FirstThunk + SecBaseAdr);
    {$else}
    PD := PDWORD64(ImportPoint.FirstThunk + SecBaseAdr);
    {$endif}

    // ImportPoint := Pointer(DWORD(ImportPoint) + SizeOf(TIMAGE_IMPORT_DESCRIPTOR));
    while (PD <> NIL) and (PD^ <> 0) do
    begin
      P := Pointer(PD^);
      if isBPPresent(P) then
      begin
        MessageBox(0, 'breakpoint detected', 'Import function breakpoint detected', MB_OK);
      end;

      PD := Pointer(Integer(PD) + SizeOf(Pointer));
    end;
  end;

end;

//==============================================================================

type
  TStdcallNoParam = function: Integer; stdcall;

procedure WaitForRun(P: Pointer); stdcall;
begin
  while True do
  begin
    TStdcallNoParam(P);
    Sleep(WaitTimeForCheckBPAPI);
  end;
end;

//==============================================================================

var
  lpThreadId: DWORD;

initialization
  lpThreadId := 0;
  CreateThread(nil, 0, @CheckAllImportForBP, @WaitForRun, 0, lpThreadId);


finalization

end.

