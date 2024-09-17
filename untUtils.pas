unit untUtils;

interface

uses System.SysUtils, System.AnsiStrings, System.Classes, Vcl.Forms,
     Dialogs, Windows;


  function Confirma(AMsg: String): Boolean;
  function _MessageBox(const Text, Caption: PChar; Flags: Longint = MB_OK): Integer;
  function ExtractNumbers(AStr: String): String;

implementation

function Confirma(AMsg: String): Boolean;
begin
  if AMsg = EmptyStr then
    AMsg := 'Confirma?';
  Result := (_MessageBox(pchar(AMsg), 'Confirmação', MB_YESNO + MB_ICONQUESTION ) = idyes);
end;

function _MessageBox(const Text, Caption: PChar; Flags: Longint = MB_OK): Integer;
Begin
  Application.NormalizeTopMosts;
  Result := Application.MessageBox(Text,Caption,Flags);
  Application.RestoreTopMosts;
End;

function ExtractNumbers(AStr: String): String;
const
  n = ['0'..'9'];
var
  i: integer;
begin
  i := 1;
  Result := EmptyStr;
  while  i <= length(AStr) do
  begin
    if CharInSet(AStr[i], n) then
      Result := Result + AStr[i];
    inc(i);
  end;
end;

end.
