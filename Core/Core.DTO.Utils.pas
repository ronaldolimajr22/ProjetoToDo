unit Core.DTO.Utils;

interface

uses
   System.Classes,
   System.SysUtils;

type
   TToken = class
   private
      FToken: String;
   public
      property token: String read FToken write FToken;
   end;

implementation

end.
