#RequireAdmin
#include <_httpRequest.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <StringConstants.au3>
#include <Array.au3>
Global $cookie, $data1
Global $cookiefb = FileReadLine("cookie.txt")
Global $Form1 = GUICreate("Tool AUTO Traodoisub.com  |  Báo lỗi  &  Update     FB :    fb.com/100000631981875", 826, 452, 383, 167)
Global $acctds = FileReadLine("njck.txt")
Global $fb_dtsg, $jazoest, $idcookie = 0
GUISetFont(10, 400, 0, "Tahoma")
$ListView1 = GUICtrlCreateListView("     TK TDS|UID FACEBOOk|              UID NHIEM VU|          Trang Thái|      XU", 8, 8, 810, 342)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 102)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 201)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 201)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 200)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 100)
GUICtrlSetColor(-1, 0x0000FF)
Global $C_Follow = GUICtrlCreateCheckbox("FOLLOW", 16, 408, 97, 17)
Global $C_LikePage = GUICtrlCreateCheckbox("LIKE FAGE", 128, 376, 97, 17)
Global $C_Like = GUICtrlCreateCheckbox("LIKE", 16, 376, 97, 17)
Global $C_Share = GUICtrlCreateCheckbox("SHARE", 128, 408, 97, 17)
Global $Input1 = GUICtrlCreateInput("0", 232, 400, 121, 24)
GUICtrlSetColor(-1, 0x0000FF)
Global $Sleep = GUICtrlCreateLabel("Sleep", 280, 376, 36, 20)
GUICtrlSetColor(-1, 0x0000FF)
Global $Button1 = GUICtrlCreateButton("Chạy Auto", 376, 376, 75, 57)
GUICtrlSetColor(-1, 0x0000FF)
Global $xu = GUICtrlCreateLabel("XU", 480, 376, 28, 20)
GUICtrlSetColor(-1, 0x0000FF)
Global $Label1 = GUICtrlCreateLabel("    000", 464, 408, 89, 20)
GUICtrlSetColor(-1, 0x0000FF)
Global $Label2 = GUICtrlCreateLabel("FREE", 624, 408, 41, 20)
GUICtrlSetColor(-1, 0x0000FF)
GUISetState(@SW_SHOW)
;Global $time = GUICtrlRead($Input1)
While 1
 Sleep(100)
 $nMsg = GUIGetMsg()
 Switch $nMsg
 Case $GUI_EVENT_CLOSE
 Exit
 Case $Button1
 _LogIn()
 Global $LogFB = _GiaTriLogFB()
 If $LogFB = True Then
 ;_logfb()
 If GUICtrlRead($C_Follow) = 1 Then _Follow()
 If GUICtrlRead($C_LikePage) = 1 Then _LikePage()
 If GUICtrlRead($C_Like) = 1 Then _Like()
 If GUICtrlRead($C_Share) = 1 Then _Share()
 Else
 MsgBox(0, 0, 'ERROR COOKIE')
 EndIf
 EndSwitch
WEnd
Func _LogIn()
 $acctds = FileReadLine("njck.txt")
 Global $uid = StringSplit($acctds, '|')[1]
 $pass = StringSplit($acctds, '|')[2]
 $data = "username=" & $uid & "&password=" & $pass & ""
 $RQ = _HttpRequest(2, "https://traodoisub.com/scr/login.php", $data, "")
 $cookie = _Getcookie($RQ)
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/like-post-cheo", "", $cookie)
 Global $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
;~  Global $additem = _GUICtrlListView_AddItem($ListView1, $uid);
;~
;~  _GUICtrlListView_AddSubItem($ListView1, $additem, $xu, 4)
 GUICtrlSetData($Label1, $xu)
 $datakey = StringRegExp($RQ3, "'key=(.*?)'", 1)[0]
 $data1 = "key=" & $datakey & ""
EndFunc   ;==>_LogIn
Func _GiaTriLogFB()
 $cookiefb = FileReadLine("cookie.txt")
 $RQ2 = _HttpRequest(2, "m.facebook.com", '', $cookiefb)
 If StringInStr($RQ2, ' class="bf bg bh">Trang chủ') Then
 Global $idcookie = StringRegExp($cookiefb, 'c_user=(\d+)', 1)[0]
 Global $fb_dtsg = StringRegExp($RQ2, 'name="fb_dtsg" value="(.*?)"', 1)[0]
 Global $jazoest = StringRegExp($RQ2, 'name="jazoest" value="(\d+)"', 1)[0]
 Return True
 EndIf
 Return False
EndFunc   ;==>_GiaTriLogFB
Func _Like()
 If $cookie <> '' And $data1 <> '' Then
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/scr/loadlike.php", $data1, $cookie)
 $dataid = $RQ3
 $Regex = 'title="http://fb.com/.*?"'
 $lishidlike = StringRegExp($dataid, $Regex, 3)
 _likeID($lishidlike)
 Return True
 EndIf
 Return False
EndFunc
Func _likeID($lishidlike)
 For $i = 0 To UBound($lishidlike) - 1
 $tachidlike = StringTrimLeft($lishidlike[$i], 21)
 $idlike = StringReplace($tachidlike, '"', '', 0)
 _GUICtrlListView_AddItem($ListView1, $uid, $i)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idcookie, 1)
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idlike, 2)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Like", 3)
 $like = "reaction_type=1&ft_ent_identifier=" & $idlike & "&m_sess=&fb_dtsg=" & _URIEncode($fb_dtsg) & "&jazoest=" & _URIEncode($jazoest) & "&__dyn=1KQEGiFo525Ujwh8-F42mml3onxG6UO3m2i5UfXwNwTwKwSwMxWUW16wZxm6Uhx6485-cwcW4olwYw9a260gq1gCwSxu0BU3JxO1ZxO3W3G1QzU1loozHzoaEau1AwgE7e1gwwyo36wqobFE8EjwaOfxW6823wp82vwAwmE2ew&__csr=&__req=6&__a=AYlhcvtz8_mvr8L7IfyDFFThVSanBCxw0lPF46kITNuE2YIaMQmLADFT7qoxpIiWisqX4HS6eidH426SnUD-n3hHf-UP-mkjxOXw6dTwEA9Awg&__user=" & $idcookie & ""
 $RQ4 = _HttpRequest(2, 'https://m.facebook.com/ufi/reaction/?ft_ent_identifier=' & $idlike & '&story_render_location=timeline&feedback_source=0&is_sponsored=0&ext=1591880803&hash=AeQGsaKiU9oh_CxL&refid=17&_ft_=mf_story_key.' & $idlike & '%3Atop_level_post_id.' & $idlike & '%3Atl_objid.' & $idlike & '%3Acontent_owner_id_new.' & $idcookie & '%3Athrowback_story_fbid.' & $idlike & '%3Aphoto_id.3247861121911589%3Astory_location.4%3Astory_attachment_style.video_inline%3Athid.' & $idcookie & '%3A306061129499414%3A2%3A0%3A1593586799%3A-6114378874524415399&__tn__=%3E*W-R&av=' & $idcookie & '&client_id=1591621615062%3A1591827627&session_id=6396150d-ea6e-4e6e-b487-8fc36f5d0d12', $like, $cookiefb)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Like Đã Ok", 3)
 $datatienlike = "id=" & $idlike & ""
 $RQ44 = _HttpRequest(2, "https://traodoisub.com/scr/nhantienlike.php", $datatienlike, $cookie)
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/like-post-cheo", "", $cookie)
 If $RQ44 = "2" Then
 Global $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 GUICtrlSetData($Label1, $xu)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 Else
 Global $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 _GUICtrlListView_AddSubItem($ListView1, $i, "ERROR", 3)
 GUICtrlSetData($Label1, $xu)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 EndIf
 Next
EndFunc
Func _LikePage()
 $RQ9 = _HttpRequest(2, "https://traodoisub.com/scr/loadpage.php", $data1, $cookie)
 $dataid1 = $RQ9
 $Regex = 'title="https://www.facebook.com/.*?"'
 $lishidlikefage = StringRegExp($dataid1, $Regex, 3)
 ;_ArrayDisplay($lishidlikefage)
 If UBound($lishidlikefage) >= 0 Then
 For $i = 0 To UBound($lishidlikefage) - 1
;~  Dim $cmt1[1] = [$lishidlikefage[1]]
 $tachidlikefage = StringTrimLeft($lishidlikefage[$i], 32)
 $idlikepage = StringReplace($tachidlikefage, '"', '', 0) ;
 _GUICtrlListView_AddItem($ListView1, $uid, $i) ;
 _GUICtrlListView_AddSubItem($ListView1, $i, $idcookie, 1)
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idlikepage, 2)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Like Page", 3)
 $likepage = "m_sess=&fb_dtsg=" & _URIEncode($fb_dtsg) & "&jazoest=" & _URIEncode($jazoest) & "&__dyn=1KQEGiFoO13xu4UpwGzWAg8-ml3kdy8qAxqcyoaU98nwCxyU6C2W3q327Eiw9G6Uhx61wzUO0PEhwai10wbm3C3y1gCwSxu0BU3JxO1ZxO3W3G1QzU1rEWUS2K2y1CwFG5o7e1gwwyo36wVwLwKCwyxe0H8-7Eow8e1Awci1qw8W1uw&__csr=&__req=h&__a=AYmAgt4Z2793rdatniHIOA2LwueTRzIKlIbrk1yWOSaFHj7USjevxSjO6KD3kdR41sx5XnVqKs55iHCP7J7b5rPzXdwJmGo1P460_A1G18M6jQ&__user=" & $idcookie & ""
 $RQ10 = _HttpRequest(2, 'https://m.facebook.com/pages/fan_status/?fbpage_id=' & $idlikepage & '&fan_origin=page_profile&fan_source=page_profile&add=true', $likepage, $cookiefb)
 ;nhận xu dưới
 $datatienfage = "id=" & $idlikepage & ""
 $RQ11 = _HttpRequest(2, "https://traodoisub.com/scr/nhantienpage.php", $datatienfage, $cookie)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Like Page Đã Ok", 3)
 If $RQ11 = "2" Then
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/like-post-cheo", "", $cookie)
 $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 GUICtrlSetData($Label1, $xu)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 Else
 _GUICtrlListView_AddSubItem($ListView1, $i, "ERROR", 3)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 EndIf
 Next
 EndIf
EndFunc
Func _Follow()
 $RQ12 = _HttpRequest(2, "https://traodoisub.com/scr/loadsub.php", $data1, $cookie)
 $dataid1 = $RQ12
 $Regex = 'title="https://www.facebook.com/.*?"'
 $lishidlikefollow = StringRegExp($dataid1, $Regex, 3)
 For $i = 0 To UBound($lishidlikefollow) - 1
 $tachidfollow = StringTrimLeft($lishidlikefollow[$i], 47)
 $idfollow = StringReplace($tachidfollow, '"', ' ', 0)
 _GUICtrlListView_AddItem($ListView1, $uid, $i)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idcookie, 1)
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idfollow, 2)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Follow", 3)
 $likeidfollow = "subject_id=" & _URIEncode($idfollow) & "&forceredirect=false&location=365&m_sess=&fb_dtsg=" & _URIEncode($fb_dtsg) & "&jazoest=" & _URIEncode($jazoest) & "&__dyn=1KQEGiFo525Ujwh8-F42mml3onxG6UO3m2i5UfXwNwTwKxu7Ec8uKew8i5orx64o720SUhwem0iy1gCwSxu0BU3JxO1ZxO3W3G1QzU1rEWUS1kU6i12wsU52229wcq3C2-2Wq2a4U2IzUuxy0wU6i0DU985G0zE5W&__csr=&__req=j&__a=AYkQNke-uIovOtM_LzPtuWiTYqhCAxOlvU059Cx5bnXCUNeiUqH5a5RTGC0ehM-jFuU5vl0qaAr5YJW0eg5T6cvCH3e7e22dTOWT0bMPDJt1cw&__user=" & $idcookie & ""
 $RQ24 = _HttpRequest(2, 'https://m.facebook.com/a/subscriptions/add', $likeidfollow, $cookiefb)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Follow Đã Ok", 3)
 $datatienfolow = "id=" & $idfollow & ""
 $RQ41 = _HttpRequest(2, "https://traodoisub.com/scr/nhantiensub.php", $datatienfolow, $cookie)
 If $RQ41 = "2" Then
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/like-post-cheo", "", $cookie)
 Global $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 GUICtrlSetData($Label1, $xu)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 Else
 _GUICtrlListView_AddSubItem($ListView1, $i, "ERROR", 3)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 EndIf
 Next
EndFunc
Func _Share()
 $RQ16 = _HttpRequest(2, "https://traodoisub.com/scr/loadshare.php", $data1, $cookie)
 $dataid1 = $RQ16
 $Regex = 'title="http://.*?"'
 $lishidshare = StringRegExp($dataid1, $Regex, 3)
 For $i = 0 To UBound($lishidshare) - 1
 $tachidshare = StringTrimLeft($lishidshare[$i], 21)
 $idshare = StringReplace($tachidshare, '"', ' ', 0)
 _GUICtrlListView_AddItem($ListView1, $uid, $i)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idcookie, 1)
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 _GUICtrlListView_AddSubItem($ListView1, $i, $idshare, 2)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Share", 3)
 $share = "m=oneclick&privacyx=300645083384735&sid=" & _URIEncode($idshare) & "&shareID=" & _URIEncode($idshare) & "&fs=8&fr=null&internal_preview_image_id=null&should_share_post=false&direct=true&_ft_=mf_story_key." & _URIEncode($idshare) & "%3Atop_level_post_id." & $idshare & "%3Atl_objid." & $idshare & "%3Acontent_owner_id_new.521457497%3Athrowback_story_fbid.10158541776922498%3Aphoto_id.10158541776892498%3Astory_location.9%3Astory_attachment_style.photo&m_sess=&fb_dtsg=" & _URIEncode($fb_dtsg) & "&jazoest=" & _URIEncode($jazoest) & "&__dyn=1KQEGiFoO13DzUjxC2GfGh0BBBgS5UqxKcyoaU98nw_K363u2W3q327HzE24xm6Uhx61Mxm1qwqEhwaG3G0Joeoe852q3q5U2nweS787S78fEeE7ifw5KzHzo5jwp84a1Pwk888C0NE6C2Wq2a4U2IzUuxy0wU6i0DU985G0zE&__csr=&__req=7&__a=AYmTAFCG-AihPcKoKQNK0aUxtYps09JncvM4PPXi0Js85opmjzVrj3KRA2vzyPv8Pk6veDr4PfXuejEVyVeeGXsX3ITtPD53TiuG6vua4Y0PfQ&__user=" & $idcookie & ""
 $RQ = _HttpRequest(2, 'https://m.facebook.com/a/sharer.php', $share, $cookiefb)
 _GUICtrlListView_AddSubItem($ListView1, $i, "Nhiệm Vụ Share Đã Ok", 3)
 $datatienshare = "id=" & $idshare & ""
 $RQ45 = _HttpRequest(2, "https://traodoisub.com/scr/nhantienshare.php", $datatienshare, $cookie)
 If $RQ45 = "2" Then
 $RQ3 = _HttpRequest(2, "https://traodoisub.com/like-post-cheo", "", $cookie)
 Global $xu = StringRegExp($RQ3, 'id="soduchinh">(.*?)</strong>', 1)[0]
 _GUICtrlListView_AddSubItem($ListView1, $i, $xu, 4)
 GUICtrlSetData($Label1, $xu)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 Else
 _GUICtrlListView_AddSubItem($ListView1, $i, "ERROR", 3)
 Sleep((Floor(Number(GUICtrlRead($Input1))) * 1000))
 EndIf
 Next
EndFunc