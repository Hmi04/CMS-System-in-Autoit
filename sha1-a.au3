#include <Crypt.au3>

Func sha1($message)
    Return _Crypt_HashData($message, $CALG_SHA1)
EndFunc

Func md5($message)
    Return _Crypt_HashData($message, $CALG_MD5)
EndFunc

Func hmac($key, $message, $hash="md5")
    Local $blocksize = 64
    Local $a_opad[$blocksize], $a_ipad[$blocksize]
    Local Const $oconst = 0x5C, $iconst = 0x36
    Local $opad = Binary(''), $ipad = Binary('')
    $key = Binary($key)
    If BinaryLen($key) > $blocksize Then $key = Call($hash, $key)
    For $i = 1 To BinaryLen($key)
        $a_ipad[$i-1] = Number(BinaryMid($key, $i, 1))
        $a_opad[$i-1] = Number(BinaryMid($key, $i, 1))
    Next
    For $i = 0 To $blocksize - 1
        $a_opad[$i] = BitXOR($a_opad[$i], $oconst)
        $a_ipad[$i] = BitXOR($a_ipad[$i], $iconst)
    Next
    For $i = 0 To $blocksize - 1
        $ipad &= Binary('0x' & Hex($a_ipad[$i],2))
        $opad &= Binary('0x' & Hex($a_opad[$i],2))
    Next
    Return Call($hash, $opad & Call($hash, $ipad & Binary($message)))
EndFunc

ConsoleWrite(hmac("tanstaaftanstaaf", "<1896.697170952@postoffice.reston.mci.net>", "sha1") & @CRLF)