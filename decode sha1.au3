#include <Crypt.au3>
#include <String.au3>
#include <Array.au3>
$message = 'the'
$key = 'key'
$key = key_fill($key)
ConsoleWrite('KeyLen = ' &StringLen($key)&@CRLF)
ConsoleWrite('Key = ' &StringToBinary($key)&@CRLF)
$opad = Encode( $key, '')
ConsoleWrite('Opad = ' & $opad & @CRLF)
$ipad = Encode($key,'6')
ConsoleWrite('Ipad = ' & $ipad & @CRLF)
$val = _Crypt_HashData($opad & _Crypt_HashData($ipad & $message, $CALG_SHA1), $CALG_SHA1)
ConsoleWrite('OutPut Hash = ' & StringLower($val) & @CRLF)
ConsoleWrite(@CRLF & 'HMAC SHA1 from website http://caligatio.github.com/jsSHA/ ' & @CRLF _
& 'Input     = the ' & @CRLF _
& 'Key   = key ' & @CRLF _
& 'OutPut Hash = 0xe2bd5b5373d0602ec959cac3f83f5d1714744853' & @CRLF)
Func key_fill($keyfill)
If StringLen($keyfill) < 64 Then
While StringLen($keyfill) < 64
$keyfill &= Chr(0)
WEnd
Else
$keyfill = _Crypt_HashData($keyfill, $CALG_SHA1)
EndIf
Return $keyfill
EndFunc ;==>key_fill
Func Encode($text, $xor)
Local $aASCII = StringToASCIIArray($text), $i
For $i = 0 To UBound($aASCII) - 1
$aASCII[$i] = Hex(BitXOR(Hex($aASCII[$i], 2), Hex(Asc($xor), 2)), 2)
Next
Return StringToBinary(_ArrayToString($aASCII, ""))
EndFunc ;==>Encode