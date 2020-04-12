unit ExtraShit;

{$mode delphi}

interface

uses
  Classes, SysUtils;

function add( a, b : integer; msg : string ): integer;

implementation

function add( a, b : integer; msg : string ): integer;
begin
  Result := a + b;
end;

end.

