Global $menu[999]=[ _
"", _
"100`Edit Your Service Call`101`100``", _
"100`Edit Your Inventory`815b`100``", _
"101`SQLMenu`102`100`SELECT DISTINCT servicecall.id,(substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2)||' ' ||starttime||' '||address.address||' ' ||servicecall.dispatchid||' ' ||company.name||' ' ||dispatch.reportedissue||' ' ||dispatch.reportedby||' ' ||dispatch.contact||' ' ||dispatch.notes||' ' ||user.name||' ' ||char(10)) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE servicecall.userid='$userid' AND dispatch.status='2'`", _
"102`Dispatch: `102`101`SELECT DISTINCT (servicecall.dispatchid||', ID:'||dispatch.equipmentid||', '||address.address||', User:'||user.name) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"102`Date: `105`101`SELECT DISTINCT substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"105`SQLMenu`105a`100`WITH RECURSIVE t(x) AS ( SELECT 1 UNION ALL SELECT x+1 FROM t WHERE x<7*6) SELECT strftime('%Y%m%d',date('now','start of month','-'||strftime('%w',date('now','start of month'))||' day','+'||x||' day','-1 day')) AS A,(CASE strftime('%w',date('now','+'||x||' days','-1 day')) WHEN '0' THEN 'Sunday' WHEN '1' THEN 'Monday' WHEN '2' THEN 'Tuesday' WHEN '3' THEN 'Wednesday' WHEN '4' THEN 'Thursday' WHEN '5' THEN 'Friday' WHEN '6' THEN 'Saturday' END)||' '||(CASE strftime('%m',date('now','start of month','-'||strftime('%w',date('now','start of month'))||' day','+'||x||' day','-1 day')) WHEN '01' THEN 'January' WHEN '02' THEN 'February' WHEN '03' THEN 'March' WHEN '04' THEN 'April' WHEN '05' THEN 'May' WHEN '06' THEN 'June' WHEN '07' THEN 'July' WHEN '08' THEN 'August' WHEN '09' THEN 'September' WHEN '10' THEN 'October' WHEN '11' THEN 'November' WHEN '12' THEN 'December' END)||' '||strftime('%d',date('now','start of month','-'||strftime('%w',date('now','start of month'))||' day','+'||x||' day','-1 day')) AS A FROM t`UPDATE OR IGNORE servicecall SET date=$rowid WHERE servicecall.id='$prowid'", _
"105a`1`102`102``", _
"102`Arrival: `106`101`SELECT DISTINCT servicecall.starttime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"106`Enter Arrival`102`102``UPDATE OR IGNORE servicecall SET starttime=(SELECT (CASE length('$typedtext') WHEN 4 THEN '0'||'$typedtext' ELSE '$typedtext' END)) WHERE servicecall.id='$rowid'", _
"102`Work Hours: `107`101`SELECT DISTINCT servicecall.time FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"107`Enter Work Hours`102`102``UPDATE OR IGNORE servicecall SET time='$typedtext' WHERE servicecall.id='$rowid';", _
"102`Travel Hours: `108`101`SELECT DISTINCT servicecall.traveltime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"108`Enter Travel Hours`102`102``UPDATE OR IGNORE servicecall SET traveltime='$typedtext' WHERE servicecall.id='$rowid';UPDATE servicecall SET travelprice=(SELECT dispatch.travelrate*servicecall.traveltime FROM servicecall LEFT JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.id=$rowid) WHERE servicecall.id=$rowid", _
"102`Solution: `109`101`SELECT DISTINCT replace(servicecall.solution,char(10),char(13)||char(10)) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"109`Enter Solution`110`110``UPDATE OR IGNORE servicecall SET solution='$typedtext' WHERE servicecall.id='$rowid'", _
"110`ml`110`112`SELECT replace(servicecall.solution,char(10),char(13)||char(10)),servicecall.solution FROM servicecall WHERE servicecall.id='$rowid'`UPDATE OR IGNORE servicecall SET solution=(SELECT DISTINCT servicecall.solution FROM servicecall WHERE servicecall.id='$rowid')||'$typedtext'||char(10) WHERE servicecall.id='$rowid'", _
"112``102`102``UPDATE OR IGNORE servicecall SET solution=(SELECT DISTINCT trim(servicecall.solution,char(10)) FROM servicecall WHERE servicecall.id='$rowid') WHERE servicecall.id='$rowid'", _
"102`Add from User Inventory`171`101``", _
"102`SQLMenu`103`101`SELECT scinv.id,(inventory.id||' - '||inventory.name||', SN:'||scinv.sn||', notes:'||scinv.notes||', Qty:'||scinv.qty) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.scid='$rowid' ORDER BY scinv.id DESC`", _
"103`Part: `103`102`SELECT (inventory.id||' - '||inventory.name||', Qty:'||scinv.qty) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"103`Modified: `103`102`SELECT (scinv.date||', By:'||user.name) AS A FROM scinv LEFT JOIN user ON user.id=scinv.userid WHERE scinv.id='$rowid' LIMIT 1`", _
"103`SN: `120`102`SELECT (scinv.sn) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"103`Notes: `121`102`SELECT (scinv.notes) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"103`Put into Own Inventory`122`102``", _
"122``123`123``INSERT or IGNORE INTO userinv(inventoryid,userid,qty,date,notes,createdby,disabled) SELECT scinv.inventoryid,'$userid','0',STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'','$userid','0' FROM scinv WHERE scinv.id='$rowid' AND NOT EXISTS(SELECT userinv.inventoryid FROM userinv LEFT JOIN scinv ON scinv.inventoryid=userinv.inventoryid WHERE scinv.id='$rowid');UPDATE OR IGNORE scinv SET qty=qty-1 WHERE scinv.inventoryid=(SELECT scinv.inventoryid FROM scinv WHERE scinv.id='$rowid' LIMIT 1) AND scinv.id='$rowid' AND scinv.qty<>0;UPDATE OR IGNORE userinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE userinv.inventoryid=(SELECT scinv.inventoryid FROM scinv WHERE scinv.id='$rowid' LIMIT 1);DELETE FROM scinv WHERE scinv.qty='0' AND scinv.id='$rowid';", _
"123`1`102`102``", _
"120`Enter Part Serial Number: `103`103``UPDATE OR IGNORE scinv SET sn='$typedtext' WHERE scinv.id='$rowid'", _
"121`Enter Part Notes: `103`103``UPDATE OR IGNORE scinv SET notes='$typedtext' WHERE scinv.id='$rowid'", _
"122``103`103``UPDATE OR IGNORE scinv SET sn='$typedtext' WHERE scinv.id='$rowid'", _
"167`Search User: `168`168``c", _
"168`SQLMenu`175`166`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege) AS OUTPUT FROM user WHERE user.name LIKE '%$rowid%' OR login LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR phone LIKE '%$rowid%' OR fullname LIKE '%$rowid%' LIMIT 14`", _
"175``166`166``", _
"169``166`166``UPDATE OR IGNORE user SET invmode=CASE invmode WHEN 'D' THEN 'W' WHEN 'W' THEN 'D' END WHERE user.id='$rowid'", _
"171``172`172`SELECT '$rowid','$rowid'`", _
"172`SQLMenu`173`102`SELECT userinv.id,(userinv.inventoryid||' - '||inventory.name||', qty:'||userinv.qty) AS OUTPUT FROM userinv LEFT JOIN inventory ON inventory.id=userinv.inventoryid WHERE userinv.userid='$userid' LIMIT 99`", _
"173``174`174``INSERT or IGNORE INTO scinv(inventoryid,scid,userid,qty,date,notes,createdby,disabled) SELECT userinv.inventoryid,'$pprowid',userinv.userid,'0',STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'','$userid','0' FROM userinv WHERE userinv.id='$rowid' AND NOT EXISTS(SELECT scinv.inventoryid FROM scinv LEFT JOIN userinv ON userinv.inventoryid=scinv.inventoryid WHERE userinv.id='$rowid' AND scinv.scid='$prowid');UPDATE OR IGNORE userinv SET qty=qty-1 WHERE userinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND userinv.id='$rowid' AND userinv.qty<>0;UPDATE OR IGNORE scinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE scinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND scinv.scid='$pprowid';DELETE FROM userinv WHERE userinv.qty='0' AND userinv.id='$rowid';", _
"174`2`102`102``", _
"152`SQLMenu`153`101`SELECT inventory.id,(''||inventory.id||', name:'||inventory.name||', shelf:'||(shelf.name)||', qty:'||qty||', notes:'||notes||', disabled:'||disabled) AS OUTPUT FROM inventory LEFT JOIN shelf ON shelf.id=inventory.shelfid WHERE disabled='0' ORDER BY inventory.id DESC LIMIT 14`", _
"153a`Enter Barcode: `153`153``INSERT OR IGNORE INTO inventory(id,name,shelfid,qty,notes,createdby,disabled) VALUES('$typedtext','','1','1','','$userid','0')", _
"154`Enter Barcode: `153`153`SELECT '$typedtext','$typedtext'`UPDATE OR IGNORE inventory SET id='$typedtext' WHERE id<>'' AND inventory.id='$rowid' AND NOT EXISTS (SELECT userinv.inventoryid FROM userinv WHERE userinv.inventoryid='$rowid')", _
"155`Enter Item Name: `153`153``UPDATE OR IGNORE inventory SET name='$typedtext' WHERE name<>'' AND inventory.id='$rowid'", _
"156`SQLMenu`157`153`SELECT shelf.id,shelf.name FROM shelf`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$prowid'", _
"157`1`153`153``", _
"160`Search Item: `160a`160a``c", _
"160a`SQLMenu`153`101`SELECT inventory.id,(inventory.name||' ') AS OUTPUT FROM inventory WHERE inventory.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$pprowid'", _
"157ss`Enter Serial: `153`153``UPDATE OR IGNORE inventory SET sn='$typedtext' WHERE inventory.id='$rowid'", _
"158`Enter Notes: `153`153``UPDATE OR IGNORE inventory SET notes='$typedtext' WHERE inventory.id='$rowid'", _
"159d``153`153``UPDATE OR IGNORE inventory SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE inventory.id='$rowid'", _
"159``153`153``UPDATE OR IGNORE inventory SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE inventory.id='$rowid'", _
"160a`Enter Barcode: `153`153`SELECT inventory.id,inventory.id FROM inventory WHERE inventory.id='$typedtext' ORDER BY inventory.id DESC LIMIT 1`INSERT OR IGNORE INTO inventory(id,shelfid,contactid,createdby,disabled) VALUES('$typedtext','1','1','$userid','0')", _
"161`Search inventory: `162`162``c", _
"162`SQLMenu`153`101`SELECT inventory.id,(id ||' '||(SELECT shelf FROM shelf WHERE inventory.shelfid=shelf.id LIMIT 1)||' '||inventory.name||' '||sn ||' ') AS OUTPUT FROM inventory WHERE inventory.id LIKE '%$rowid%' OR inventory.name LIKE '%$rowid%' OR sn LIKE '%$rowid%' LIMIT 14`", _
"163`UPDATE OR IGNORE Total Quantity: `153`153``UPDATE OR IGNORE inventory SET qty='$typedtext' WHERE inventory.id='$rowid'", _
"164`UPDATE OR IGNORE Cost: `153`153``UPDATE OR IGNORE inventory SET cost='$typedtext' WHERE inventory.id='$rowid'", _
"102`Add Form`140`401``", _
"140`SQLMenu`140a`401`SELECT DISTINCT formfieldtitle.id,formfieldtitle.name FROM formfieldtitle WHERE formfieldtitle.disabled='0'`", _
"140a``102`102`SELECT scformfields.scid,scformfields.scid FROM scformfields ORDER BY scformfields.id DESC LIMIT 1`INSERT OR IGNORE INTO scformfields(formfieldtitleid,scid) VALUES('$rowid','$prowid');INSERT OR IGNORE INTO scf(scformfields,scfcolid,formfieldtitleid,value,scid) SELECT (SELECT scformfields.id FROM scformfields ORDER BY scformfields.id DESC LIMIT 1),formfields.id AS scfcolid,formfields.fgrp AS formfieldtitleid,'' AS value,'$prowid' AS scid FROM formfields WHERE formfields.fgrp='$rowid'", _
"102`SQLMenu`141`102`SELECT scformfields.id, (formfieldtitle.name) AS OUTPUT FROM scformfields LEFT JOIN formfieldtitle ON formfieldtitle.id=scformfields.formfieldtitleid WHERE scformfields.scid='$rowid'`", _
"102`Status Close, now: `130`101`SELECT status.status FROM servicecall LEFT JOIN status ON status.id=servicecall.status WHERE servicecall.id='$rowid'`", _
"130``131`131``UPDATE OR IGNORE servicecall SET status=(SELECT status.id FROM status WHERE status.status='Closed' LIMIT 1) WHERE servicecall.id='$rowid';UPDATE dispatch SET status=(SELECT servicecall.status FROM servicecall WHERE servicecall.dispatchid=(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id=$rowid) ORDER BY servicecall.status ASC LIMIT 1) WHERE dispatch.id=(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id=$rowid)", _
"131`screport`135`101`SELECT servicecall.dispatchid,servicecall.dispatchid FROM servicecall WHERE servicecall.id='$prowid'`", _
"134`3`135`101``", _
"135`2`102`102``", _
"134a`closedispatch`102`101``UPDATE OR IGNORE dispatch SET status=SELECT (CASE count(DISTINCT servicecall.status) WHEN 1 THEN '3' ELSE '2' END) AS A FROM servicecall WHERE servicecall.dispatchid='$prowid'", _
"141`SQLMenu`142`102`SELECT DISTINCT scf.id,(formfields.fieldname||': '||scf.value) AS A FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$pprowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99`", _
"141`Delete Form`145`102``", _
"145``145a`145a``DELETE FROM scformfields WHERE scformfields.id IN(SELECT scformfields.id FROM scformfields WHERE scformfields.id='$rowid' LIMIT 1);DELETE FROM scf WHERE scf.id IN(SELECT DISTINCT scf.id FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$prowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99)", _
"145a`1`102`102``", _
"142`Enter Valued`143`143``UPDATE OR IGNORE scf SET value='$typedtext' WHERE scf.id='$rowid'", _
"143`1`141`141``", _
"100`Create Dispatch`201`101``", _
"201`Find by Dispatch Number`203`100``", _
"203`Enter Dispatch Number: `204`204``c", _
"204`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' sn:'||equipment.sn||' notes:'||equipment.notes||char(10)) AS OUTPUT FROM equipment LEFT JOIN dispatch ON dispatch.equipmentid=equipment.id WHERE dispatch.id='$rowid'`", _
"205`Enter Reported Issue:`406`406`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes) AS OUTPUT  FROM dispatch ORDER BY dispatch.id DESC LIMIT 1`INSERT OR IGNORE INTO dispatch(equipmentid,addressid,contactid,date,contracttype,reportedissue,hourlyrate,travelrate,status,createdby,disabled) VALUES('$rowid',(SELECT addressid FROM equipment where equipment.id='$rowid'),(SELECT contactid FROM equipment where equipment.id='$rowid'),STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),(SELECT ifnull((SELECT quote.contracttype FROM equipment LEFT JOIN quote,qtscope ON (quote.contactid=equipment.contactid AND quote.startdate<=strftime('%Y%m%d',date('now')) AND quote.enddate>=strftime('%Y%m%d',date('now')) AND qtscope.qtid=quote.id AND qtscope.typeid=equipment.typeid) LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid' GROUP by quote.contracttype),0)),'$typedtext',(SELECT type.hourlyrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),(SELECT type.travelrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),'1','$userid','0')", _
"201`Find by Address`205b`100``", _
"205b`Enter Address: `205c`205c``c", _
"205c`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||address.address||' '||address.city||' '||address.state||' '||address.zip||' '||address.country||' '||equipment.name||' sn:'||equipment.sn||' notes:'||equipment.notes||char(10)) AS OUTPUT FROM equipment LEFT JOIN address ON address.id=equipment.addressid WHERE address.address LIKE '%$rowid%' OR address.city LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.zip LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.country LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"210`Enter Address: `206`206``", _
"206`Dispatch: `206`201`SELECT DISTINCT (dispatch.id||', '||address.address) AS OUTPUT FROM dispatch LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE dispatch.id='$rowid' LIMIT 1`", _
"206`Equipment ID: `206`201`SELECT DISTINCT dispatch.equipmentid FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Work Type: `234`201`SELECT DISTINCT worktype.worktype FROM dispatch LEFT JOIN worktype ON worktype.id=dispatch.worktype WHERE dispatch.id='$rowid'`", _
"234`SQLMenu`206`201`SELECT DISTINCT worktype.id, (worktype.worktype) ORDER BY worktype.id ASC LIMIT 20`", _
"206`Reported Date: `206`201`SELECT DISTINCT (substr(dispatch.date,1,4)||'-'||substr(dispatch.date,5,2)||'-'||substr(dispatch.date,7,2)||' '||substr(dispatch.date,9,2)||':'||substr(dispatch.date,11,2)) FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Reported Issue: `207`201`SELECT DISTINCT dispatch.reportedissue FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Reported By: `207`201`SELECT DISTINCT dispatch.reportedby FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Reported Contact: `208`201`SELECT DISTINCT dispatch.contact FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Info: `209`201`SELECT DISTINCT dispatch.notes FROM dispatch WHERE dispatch.id='$rowid'`", _
"206`Dispatched User: `207`201`SELECT group_concat(name) as name FROM (SELECT DISTINCT name from servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE dispatchid='$rowid' ORDER BY userid DESC)`", _
"206`Status: `207`201`SELECT DISTINCT dispatch.status FROM dispatch WHERE dispatch.id='$rowid'`", _
"207`Enter Person who called in: `206`206``UPDATE OR IGNORE dispatch SET reportedby='$typedtext' WHERE dispatch.id='$rowid'", _
"208`Enter Phone: `206`206``UPDATE OR IGNORE dispatch SET contact='$typedtext' WHERE dispatch.id='$rowid'", _
"209`Enter Notes: `206`206``UPDATE OR IGNORE dispatch SET notes='$typedtext' WHERE dispatch.id='$rowid'", _
"201`Find by Contact `220`100``", _
"220`Enter Contact Name: `221`221``c", _
"221`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||contacts.name||' '||company.name||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN contacts ON contacts.id=equipment.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.name LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by Company `222`100``", _
"222`Enter Company Name: `223`223``c", _
"223`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||contacts.name||' '||company.name||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN contacts ON contacts.id=equipment.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by Reported Issue `224`100``", _
"224`Enter Issue: `225`225``c", _
"225`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||dispatch.reportedissue||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN dispatch ON dispatch.equipmentid=equipment.id WHERE dispatch.reportedissue LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by Reported By`226`100``", _
"226`Enter Reported By: `227`227``c", _
"227`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||dispatch.reportedby||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN dispatch ON dispatch.equipmentid=equipment.id WHERE dispatch.reportedby LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by User `228`100``", _
"228`Enter Dispatched User Name: `229`229``c", _
"229`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||user.login||' '||user.fullname||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM dispatch LEFT JOIN equipment ON dispatch.equipmentid=equipment.id LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN user ON servicecall.userid=user.id WHERE user.fullname LIKE '%$rowid%' OR user.login LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by Equipment ID`230`100``", _
"230`Enter Equipment ID: `231`231``c", _
"231`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||address.address||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN address ON address.id=equipment.addressid WHERE equipment.id LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"201`Find by Equipment Name`232`100``", _
"232`Enter Equipment Name: `233`233``c", _
"233`SQLMenu`205`201`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' '||address.address||' sn:'||equipment.sn||char(10)) AS OUTPUT FROM equipment LEFT JOIN address ON address.id=equipment.addressid WHERE equipment.name LIKE '%$rowid%' ORDER BY equipment.id DESC LIMIT 14`", _
"100`Edit Users`301`101``", _
"301`List Existing Users`302`100``", _
"301`Add User`303`100``", _
"301`Find User`316`100``", _
"302`SQLMenu`304`301`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege||char(10)) AS OUTPUT FROM user ORDER BY user.id DESC LIMIT 14`", _
"316`Search User: `317`317``c", _
"317`SQLMenu`304`301`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege||char(10)) AS OUTPUT FROM user WHERE user.name LIKE '%$rowid%' OR login LIKE '%$rowid%' OR fullname LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR phone LIKE '%$rowid%' LIMIT 14`", _
"303`Enter New User Login:`304`304`SELECT user.id,user.id FROM user ORDER BY user.id DESC LIMIT 1`INSERT OR IGNORE INTO user(login,name,fullname,password,createdby,disabled) VALUES('$typedtext','$typedtext','$typedtext','$typedtext','$userid','0')", _
"304`Login: `305`301`SELECT DISTINCT user.login FROM user WHERE user.id='$rowid'`", _
"304`Name: `306`301`SELECT DISTINCT user.name FROM user WHERE user.id='$rowid'`", _
"304`Full Name: `307`301`SELECT DISTINCT user.fullname FROM user WHERE user.id='$rowid'`", _
"304`Phone: `308`301`SELECT DISTINCT user.phone FROM user WHERE user.id='$rowid'`", _
"304`Email: `309`301`SELECT DISTINCT user.email FROM user WHERE user.id='$rowid'`", _
"304`Privilege: `310`301`SELECT DISTINCT user.privilege FROM user WHERE user.id='$rowid'`", _
"304`Password: `311`301`SELECT DISTINCT user.password FROM user WHERE user.id='$rowid'`", _
"304`Trusted IP Address: `312`301`SELECT DISTINCT user.trustedip FROM user WHERE user.id='$rowid'`", _
"304`Barcode: `313`301`SELECT DISTINCT user.invbarcode FROM user WHERE user.id='$rowid'`", _
"304`Home Menu: `314`301`SELECT DISTINCT user.menu FROM user WHERE user.id='$rowid'`", _
"304`Disabled: `315`301`SELECT DISTINCT user.disabled FROM user WHERE user.id='$rowid'`", _
"305`Enter login: `304`304``UPDATE OR IGNORE user SET login='$typedtext' WHERE user.id='$rowid'", _
"306`Enter Short Name: `304`304``UPDATE OR IGNORE user SET name='$typedtext' WHERE user.id='$rowid'", _
"307`Enter Full Name: `304`304``UPDATE OR IGNORE user SET fullname='$typedtext' WHERE user.id='$rowid'", _
"308`Enter Phone: `304`304``UPDATE OR IGNORE user SET phone='$typedtext' WHERE user.id='$rowid'", _
"309`Enter Email: `304`304``UPDATE OR IGNORE user SET email='$typedtext' WHERE user.id='$rowid'", _
"310`Enter Privilege: `304`304``UPDATE OR IGNORE user SET privilege='$typedtext' WHERE user.id='$rowid'", _
"311`Enter Password: `304`304``UPDATE OR IGNORE user SET password='$typedtext' WHERE user.id='$rowid'", _
"312`Enter No Login Required IP Address: `304`304``UPDATE OR IGNORE user SET trustedip='$typedtext' WHERE user.id='$rowid'", _
"313`Enter Barcode: `304`304``UPDATE OR IGNORE user SET invbarcode='$typedtext' WHERE user.id='$rowid'", _
"314`Enter Home Menu: `304`304``UPDATE OR IGNORE user SET menu='$typedtext' WHERE user.id='$rowid'", _
"315``304`304``UPDATE OR IGNORE user SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE user.id='$rowid'", _
"100`Edit Dispatch`401`101``", _
"100`Edit Companies`D01`101``", _
"100`Edit Customer Contact`501`101``", _
"100`Edit Equipment`601`101``", _
"100`Edit Address`701`101``", _
"100`Edit Sales Taxes`X01`101``", _
"100`Edit Work Type`W01`101``", _
"401`List Some Prior Entered Dispatches`404`100``", _
"401`Add Dispatch`405`100``", _
"401`Find Dispatch`413`100``", _
"413`Search Dispatch: `413a`413a``c", _
"413a`SQLMenu`406`401`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes||char(10)) AS OUTPUT FROM dispatch WHERE dispatch.id LIKE '%$rowid%' OR equipmentid LIKE '%$rowid%' OR reportedissue LIKE '%$rowid%' OR reportedby LIKE '%$rowid%' OR dispatch.contact LIKE '%$rowid%' LIMIT 14`", _
"404`SQLMenu`406`401`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch  LEFT JOIN address ON dispatch.addressid=address.id ORDER BY dispatch.id DESC LIMIT 14`", _
"405`Enter Equipment ID: `405a`405a``c", _
"405a`SQLMenu`405b`401`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' sn:'||equipment.sn||' notes:'||equipment.notes||char(10)) AS OUTPUT FROM equipment WHERE equipment.id='$rowid'`", _
"405b`Enter Reported Issue:`406`406`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes) AS OUTPUT  FROM dispatch ORDER BY dispatch.id DESC LIMIT 1 `INSERT OR IGNORE INTO dispatch(equipmentid,addressid,contactid,date,contracttype,reportedissue,hourlyrate,travelrate,status,createdby,disabled) VALUES('$rowid',(SELECT addressid FROM equipment where equipment.id='$rowid'),(SELECT contactid FROM equipment where equipment.id='$rowid'),STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),(SELECT ifnull((SELECT quote.contracttype FROM equipment LEFT JOIN quote,qtscope ON (quote.contactid=equipment.contactid AND quote.startdate<=strftime('%Y%m%d',date('now')) AND quote.enddate>=strftime('%Y%m%d',date('now')) AND qtscope.qtid=quote.id AND qtscope.typeid=equipment.typeid) LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid' GROUP by quote.contracttype),0)),'$typedtext',(SELECT type.hourlyrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),(SELECT type.travelrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),'1','$userid','0')", _
"406`Dispatch: `406`401`SELECT DISTINCT (dispatch.id||', '||address.address) AS OUTPUT FROM dispatch LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE dispatch.id='$rowid' LIMIT 1`", _
"406`Equipment ID: `407`401`SELECT DISTINCT dispatch.equipmentid FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Contract Type: `430`401`SELECT contracttype.title FROM contracttype LEFT JOIN dispatch ON dispatch.contracttype=contracttype.id WHERE dispatch.id=$rowid`", _
"430`SQLMenu`431`406`SELECT contracttype.id,(contracttype.title) AS A FROM contracttype`UPDATE OR IGNORE dispatch SET contracttype='$rowid' WHERE dispatch.id='$prowid'", _
"431`1`406`406``", _
"406`Work Type: `436`401`SELECT worktype.worktype FROM dispatch LEFT JOIN worktype ON worktype.id=dispatch.worktype WHERE dispatch.id='$rowid'`", _
"436`SQLMenu`431`401`SELECT worktype.id, (worktype.worktype) FROM worktype ORDER BY worktype.id ASC LIMIT 20`UPDATE OR IGNORE dispatch SET worktype='$rowid' WHERE dispatch.id='$prowid'", _
"406`Reported Date: `406`401`SELECT DISTINCT (substr(dispatch.date,1,4)||'-'||substr(dispatch.date,5,2)||'-'||substr(dispatch.date,7,2)||' '||substr(dispatch.date,9,2)||':'||substr(dispatch.date,11,2)) FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Reported Issue: `409`401`SELECT DISTINCT dispatch.reportedissue FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Reported By: `410`401`SELECT DISTINCT dispatch.reportedby FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Reported Contact: `411`401`SELECT DISTINCT dispatch.contact FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Notes: `412`401`SELECT DISTINCT dispatch.notes FROM dispatch WHERE dispatch.id='$rowid'`", _
"406`Add User to Dispatch `415`401``", _
"406`SQLMenu`417`406`SELECT servicecall.id, (user.name ||' '||substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) ||' '||servicecall.starttime ||' h:'||servicecall.time ||' t:'||servicecall.traveltime) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id=servicecall.userid WHERE dispatchid='$rowid' AND servicecall.disabled='0' ORDER BY servicecall.date DESC`", _
"406`Add Self to Dispatch `417d`401``", _
"431`SQLMenu`432`406`SELECT DISTINCT scf.id,(formfields.fieldname||': '||scf.value) AS A FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$pprowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99`", _
"431`Delete Form`435`406``", _
"435``406`406`SELECT '$prowid','$prowid'`DELETE FROM scformfields WHERE scformfields.id IN(SELECT scformfields.id FROM scformfields WHERE scformfields.id='$rowid' LIMIT 1);DELETE FROM scf WHERE scf.id IN(SELECT DISTINCT scf.id FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$pprowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99)", _
"432`Enter Value`433`433`SELECT '$prowid','$prowid'`UPDATE OR IGNORE scf SET value='$typedtext' WHERE scf.id='$rowid'", _
"433``434`434`SELECT scf.scid,scf.scid FROM scf WHERE id='$rowid'`", _
"434``431`431`SELECT '$prowid','$prowid'`", _
"406`Status: `414`401`SELECT DISTINCT (dispatch.status ||' '||status.status) AS OUTPUT FROM dispatch LEFT JOIN status ON status.id=dispatch.status WHERE dispatch.id='$rowid'`", _
"455``456`456``UPDATE OR IGNORE servicecall SET status=(SELECT status.id FROM status WHERE status.status='Closed' LIMIT 1) WHERE servicecall.dispatchid='$rowid'", _
"456`screport`457`406`SELECT servicecall.dispatchid,servicecall.dispatchid FROM servicecall WHERE servicecall.id='$rowid'`", _
"457``458`458`SELECT 1,(CASE count(1) WHEN 1 THEN substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) ELSE '0' END) AS A FROM servicecall WHERE servicecall.dispatchid='$rowid' AND substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2)='$prowid' GROUP BY (servicecall.status) HAVING servicecall.status`", _
"458``459`459``UPDATE OR IGNORE dispatch SET status= (SELECT CASE count(DISTINCT servicecall.status) WHEN 1 THEN '3' ELSE '2' END  FROM servicecall JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.dispatchid='$prowid') WHERE dispatch.id='$prowid'", _
"459`3`460`460``", _
"460`2`406`406``", _
"407d`Enter Equipment: `406`406``UPDATE OR IGNORE dispatch SET equipmentid='$typedtext' WHERE dispatch.id='$rowid'", _
"407`Search Equipment: `418`418``c", _
"418`SQLMenu`419`406`SELECT equipment.id,(equipment.id ||' '||(SELECT address FROM address WHERE equipment.addressid=address.id LIMIT 1)||' '||equipment.name||' '||sn ||' ') AS OUTPUT FROM equipment WHERE equipment.id LIKE '%$rowid%' OR equipment.name LIKE '%$rowid%' OR sn LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE dispatch SET equipmentid='$rowid' WHERE dispatch.id='$pprowid'", _
"419`2`406`406``", _
"408`Enter Date: `406`406``UPDATE OR IGNORE dispatch SET date=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE dispatch.id='$rowid'", _
"409`Enter Issue: `406`406``UPDATE OR IGNORE dispatch SET reportedissue='$typedtext' WHERE dispatch.id='$rowid'", _
"410`Enter Person who called in: `406`406``UPDATE OR IGNORE dispatch SET reportedby='$typedtext' WHERE dispatch.id='$rowid'", _
"411`Enter Phone: `406`406``UPDATE OR IGNORE dispatch SET contact='$typedtext' WHERE dispatch.id='$rowid'", _
"412`Enter Notes: `406`406``UPDATE OR IGNORE dispatch SET notes='$typedtext' WHERE dispatch.id='$rowid'", _
"415`Enter Dispatched User: `416`416``c", _
"416`SQLMenu`417b`401`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege) AS OUTPUT FROM user WHERE user.name LIKE '%$rowid%' OR login LIKE '%$rowid%' OR fullname LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR phone LIKE '%$rowid%' LIMIT 14`", _
"417b`Enter Onsite Date:`417c`417c``INSERT OR IGNORE INTO servicecall(dispatchid,userid,date,createdby,disabled) VALUES('$pprowid','$rowid',replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':',''),'$userid','0');UPDATE OR IGNORE dispatch SET status='2' WHERE dispatch.id='$pprowid'", _
"417c`2`406`406``", _
"417d`Enter Onsite Date:`406`406``INSERT OR IGNORE INTO servicecall(dispatchid,userid,date,createdby,disabled) VALUES('$rowid','$userid',replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':',''),'$userid','0');UPDATE OR IGNORE dispatch SET status='2' WHERE dispatch.id='$rowid'", _
"f417b`SQLMenu`417`401`SELECT servicecall.id,servicecall.id FROM servicecall ORDER BY servicecall.id DESC LIMIT 1`", _
"414`Enter Status: `406`406``UPDATE OR IGNORE dispatch SET status='$typedtext' WHERE dispatch.id='$rowid'", _
"417`User: `423`406`SELECT DISTINCT (user.name ||' id: '||servicecall.userid||' sc: '||servicecall.id||' Dispatch: '||servicecall.dispatchid) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Date: `424`406`SELECT DISTINCT substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Arrival: `425`406`SELECT DISTINCT servicecall.starttime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Work Hours: `426`406`SELECT DISTINCT servicecall.time FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Travel Hours: `427`406`SELECT DISTINCT servicecall.traveltime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Solution: `428`406`SELECT DISTINCT replace(servicecall.solution,char(10),char(13)||char(10)) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"417`Add from User Inventory`450`406``", _
"417`SQLMenu`420`101`SELECT scinv.id,(inventory.id||' - '||inventory.name||', SN:'||scinv.sn||', notes:'||scinv.notes||', Qty:'||scinv.qty) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.scid='$rowid' ORDER BY scinv.id DESC`", _
"450``451`451`SELECT '$rowid','$rowid'`", _
"451`SQLMenu`452`453`SELECT userinv.id,(userinv.inventoryid||' - '||inventory.name||', qty:'||userinv.qty) AS OUTPUT FROM userinv LEFT JOIN inventory ON inventory.id=userinv.inventoryid WHERE userinv.userid='$userid' LIMIT 99`", _
"452``453`453``INSERT or IGNORE INTO scinv(inventoryid,scid,userid,qty,date,notes,createdby,disabled) SELECT userinv.inventoryid,'$prowid','$userid','0',STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'','$userid','0' FROM userinv WHERE userinv.id='$rowid' AND NOT EXISTS(SELECT scinv.inventoryid FROM scinv LEFT JOIN userinv ON userinv.inventoryid=scinv.inventoryid WHERE userinv.id='$rowid' AND scinv.scid='$prowid');UPDATE OR IGNORE userinv SET qty=qty-1 WHERE userinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND userinv.id='$rowid' AND userinv.qty<>0;UPDATE OR IGNORE scinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE scinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND scinv.scid='$prowid';DELETE FROM userinv WHERE userinv.qty='0' AND userinv.id='$rowid';", _
"453`3`417`417``", _
"420`Part: `420`417`SELECT (inventory.id||' - '||inventory.name||', Qty:'||scinv.qty) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"420`SN: `421`417`SELECT (scinv.sn) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"420`Notes: `422`417`SELECT (scinv.notes) AS A FROM scinv LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE scinv.id='$rowid' LIMIT 1`", _
"420`Put into Own Inventory`446`417``", _
"446``447`447``INSERT or IGNORE INTO userinv(inventoryid,userid,qty,date,notes,createdby,disabled) SELECT scinv.inventoryid,'$userid','0',STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'','$userid','0' FROM scinv WHERE scinv.id='$rowid' AND NOT EXISTS(SELECT userinv.inventoryid FROM userinv LEFT JOIN scinv ON scinv.inventoryid=userinv.inventoryid WHERE scinv.id='$rowid');UPDATE OR IGNORE scinv SET qty=qty-1 WHERE scinv.inventoryid=(SELECT scinv.inventoryid FROM scinv WHERE scinv.id='$rowid' LIMIT 1) AND scinv.id='$rowid' AND scinv.qty<>0;UPDATE OR IGNORE userinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE userinv.inventoryid=(SELECT scinv.inventoryid FROM scinv WHERE scinv.id='$rowid' LIMIT 1);DELETE FROM scinv WHERE scinv.qty='0' AND scinv.id='$rowid';", _
"447`1`417`417``", _
"421`Enter Part Serial Number`420`420``UPDATE OR IGNORE scinv SET sn='$typedtext' WHERE scinv.id='$rowid'", _
"422`Enter Part Notes`420`420``UPDATE OR IGNORE scinv SET notes='$typedtext' WHERE scinv.id='$rowid'", _
"423``420`420``UPDATE OR IGNORE scinv SET sn='$typedtext' WHERE scinv.id='$rowid'", _
"417`Add Form`440`401``", _
"440`SQLMenu`440a`401`SELECT DISTINCT formfieldtitle.id,formfieldtitle.name FROM formfieldtitle WHERE formfieldtitle.disabled='0'`", _
"440a``417`417`SELECT scformfields.scid,scformfields.scid FROM scformfields ORDER BY scformfields.id DESC LIMIT 1`INSERT OR IGNORE INTO scformfields(formfieldtitleid,scid) VALUES('$rowid','$prowid');INSERT OR IGNORE INTO scf(scformfields,scfcolid,formfieldtitleid,value,scid) SELECT (SELECT scformfields.id FROM scformfields ORDER BY scformfields.id DESC LIMIT 1),formfields.id AS scfcolid,formfields.fgrp AS formfieldtitleid,'' AS value,'$prowid' AS scid FROM formfields WHERE formfields.fgrp='$rowid'", _
"417`SQLMenu`441`417`SELECT scformfields.id, (formfieldtitle.name) AS OUTPUT FROM scformfields LEFT JOIN formfieldtitle ON formfieldtitle.id=scformfields.formfieldtitleid WHERE scformfields.scid='$rowid'`", _
"441`SQLMenu`442`417`SELECT DISTINCT scf.id,(formfields.fieldname||': '||scf.value) AS A FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$pprowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99`", _
"441`Delete Form`445`417``", _
"445``445a`445a``DELETE FROM scformfields WHERE scformfields.id IN(SELECT scformfields.id FROM scformfields WHERE scformfields.id='$rowid' LIMIT 1);DELETE FROM scf WHERE scf.id IN(SELECT DISTINCT scf.id FROM scf LEFT JOIN formfieldtitle ON formfieldtitle.id=scf.formfieldtitleid AND scf.scformfields='$rowid' LEFT JOIN formfields ON scf.scformfields='$rowid' AND formfields.id=scf.scfcolid WHERE scf.scid='$prowid' AND scf.scformfields='$rowid' AND formfields.fgrp=scf.formfieldtitleid ORDER BY formfields.id ASC LIMIT 99)", _
"445a`1`417`417``", _
"442`Enter Valued`443`443``UPDATE OR IGNORE scf SET value='$typedtext' WHERE scf.id='$rowid'", _
"443`1`441`441``", _
"417`Status Close, now: `448`406`SELECT status.status FROM servicecall LEFT JOIN status ON status.id=servicecall.status WHERE servicecall.id='$rowid'`", _
"448``417`417``UPDATE OR IGNORE servicecall SET status=(SELECT status.id FROM status WHERE status.status='Closed' LIMIT 1) WHERE servicecall.id='$rowid';UPDATE dispatch SET status=(SELECT servicecall.status FROM servicecall WHERE servicecall.dispatchid=(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id=$rowid) ORDER BY servicecall.status ASC LIMIT 1) WHERE dispatch.id=(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id=$rowid)", _
"417`Disabledd: `429`406`SELECT DISTINCT servicecall.disabled FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"423`Enter User`417`417``UPDATE OR IGNORE servicecall SET userid='$typedtext' WHERE servicecall.id='$rowid'", _
"424`Enter Date`417`417``UPDATE OR IGNORE servicecall SET date=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE servicecall.id='$rowid'", _
"425`Enter Arrival`417`417``UPDATE OR IGNORE servicecall SET starttime=(SELECT (CASE length('$typedtext') WHEN 4 THEN '0'||'$typedtext' ELSE '$typedtext' END)) WHERE servicecall.id='$rowid'", _
"426`Enter Work Hours`417`417``UPDATE OR IGNORE servicecall SET time='$typedtext' WHERE servicecall.id='$rowid';", _
"427`Enter Travel Hours`417`417``UPDATE OR IGNORE servicecall SET traveltime='$typedtext' WHERE servicecall.id='$rowid';UPDATE servicecall SET travelprice=(SELECT dispatch.travelrate*servicecall.traveltime FROM servicecall LEFT JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.id=$rowid) WHERE servicecall.id=$rowid", _
"428`Enter Solution`417`417``UPDATE OR IGNORE servicecall SET solution='$typedtext' WHERE servicecall.id='$rowid'", _
"429``417`417``UPDATE OR IGNORE servicecall SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE servicecall.id='$rowid';UPDATE OR IGNORE dispatch SET status='1' WHERE dispatch.id in(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id='$rowid' LIMIT 1) AND NOT EXISTS (SELECT servicecall.userid FROM servicecall WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' LIMIT 1)", _
"D01`Add Company`D15`100``", _
"D01`Find Company`D16`100``", _
"D01`SQLMenu`D03`D01`SELECT company.id,(company.name||', '||(SELECT address FROM address WHERE company.addressid=address.id LIMIT 1)) AS OUTPUT FROM company ORDER BY company.id DESC LIMIT 14`", _
"D03`Name: `D04`D01`SELECT DISTINCT company.name FROM company WHERE company.id='$rowid'`", _
"D03`Address: `D06`D01`SELECT address FROM address LEFT JOIN company ON company.addressid=address.id WHERE company.id='$rowid' LIMIT 1`", _
"D03`Email: `D08`D01`SELECT DISTINCT company.email FROM company WHERE company.id='$rowid'`", _
"D03`Office Phone: `D09`D01`SELECT DISTINCT company.officephone FROM company WHERE company.id='$rowid'`", _
"D03`Cell Phone: `D10`D01`SELECT DISTINCT company.cellphone FROM company WHERE company.id='$rowid'`", _
"D03`Fax: `D11`D01`SELECT DISTINCT fax FROM company WHERE company.id='$rowid'`", _
"D03`Charge Tax: `D18`D01`SELECT (CASE company.plustax WHEN '1' THEN 'YES' ELSE 'NO' END) AS A FROM company WHERE company.id='$rowid' LIMIT 1``", _
"D03`Website: `D12`D01`SELECT DISTINCT website FROM company WHERE company.id='$rowid'`", _
"D03`Notes: `D13`D01`SELECT DISTINCT notes FROM company WHERE company.id='$rowid'`", _
"D03`Created by: `D03`D01`SELECT (user.name||', '||'U'||PRINTF('%01d',company.createdby)) AS A FROM company LEFT JOIN user on user.id=company.createdby WHERE company.id='$rowid'`", _
"D03`Disabled: `D14`D01`SELECT DISTINCT disabled FROM company WHERE company.id='$rowid'`", _
"D03`SQLMenu`603`D01`SELECT equipment.id,('ID:'||equipment.id||', N:'||equipment.name||', '||(SELECT address.address FROM address WHERE equipment.addressid=address.id LIMIT 1)||', C:'||contacts.name) AS OUTPUT FROM equipment LEFT JOIN contacts ON contacts.id=equipment.contactid LEFT JOIN company ON company.id=contacts.companyid  WHERE contacts.companyid='$rowid' ORDER BY equipment.id DESC LIMIT 99`", _
"D04`Enter Name: `D03`D03``UPDATE OR IGNORE company SET name='$typedtext' WHERE company.id='$rowid'", _
"D06`Search Address: `D06a`D06a``c", _
"D06a`SQLMenu`D06c`D03`SELECT address.id,(address.address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE company SET addressid='$rowid' WHERE company.id='$pprowid'", _
"D06b``D06c`D06c`SELECT '$prowid','$prowid'`", _
"D06c`2`D03`D03``", _
"D08`Enter Email: `D03`D03``UPDATE OR IGNORE company SET email='$typedtext' WHERE company.id='$rowid'", _
"D09`Enter Office Phone: `D03`D03``UPDATE OR IGNORE company SET officephone='$typedtext' WHERE company.id='$rowid'", _
"D10`Enter Cell Phone: `D03`D03``UPDATE OR IGNORE company SET cellphone='$typedtext' WHERE company.id='$rowid'", _
"D11`Enter Fax: `D03`D03``UPDATE OR IGNORE company SET fax='$typedtext' WHERE company.id='$rowid'", _
"D12`Enter Website: `D03`D03``UPDATE OR IGNORE company SET website='$typedtext' WHERE company.id='$rowid'", _
"D13`Enter Notes: `D03`D03``UPDATE OR IGNORE company SET notes='$typedtext' WHERE company.id='$rowid'", _
"D14``D03`D03``UPDATE OR IGNORE company SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE company.id='$rowid'", _
"D15`Enter Company Name: `D03`D03`SELECT company.id,company.id FROM company ORDER BY company.id DESC LIMIT 1`INSERT OR IGNORE INTO company(name,addressid,plustax,createdby,disabled) VALUES('$typedtext',0,1,'$userid',0)", _
"D16`Search Company Name: `D17`D17``c", _
"D17`SQLMenu`D03`D16`SELECT company.id,(company.name ||' '||company.email ||' '||company.officephone||' '||company.cellphone) AS OUTPUT FROM company WHERE company.name LIKE '%$rowid%' OR company.email LIKE '%$rowid%' OR company.officephone LIKE '%$rowid%' OR company.cellphone LIKE '%$rowid%' LIMIT 14`", _
"D18``D03`D03``UPDATE OR IGNORE company SET plustax=CASE plustax WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE company.id='$rowid'", _
"501`Add Contact`515`100``", _
"501`Find Contact`516`100``", _
"501`SQLMenu`503`100`SELECT contacts.id,('ID:'||contacts.id||', '||contacts.name||', '||(SELECT address FROM address WHERE contacts.addressid=address.id LIMIT 1)||', '||company.name||'') AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid ORDER BY contacts.id DESC LIMIT 14`", _
"503`Name: `504`501`SELECT DISTINCT contacts.name FROM contacts WHERE contacts.id='$rowid'`", _
"503`Position: `505`501`SELECT DISTINCT title FROM contacts WHERE contacts.id='$rowid'`", _
"503`Address: `506`501`SELECT address FROM address LEFT JOIN contacts ON contacts.addressid=address.id WHERE contacts.id='$rowid' LIMIT 1`", _
"503`Company: `507`501`SELECT DISTINCT company.name FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.id='$rowid'`", _
"503`Email: `508`501`SELECT DISTINCT contacts.email FROM contacts WHERE contacts.id='$rowid'`", _
"503`Office Phone: `509`501`SELECT DISTINCT officephone FROM contacts WHERE contacts.id='$rowid'`", _
"503`Cell Phone: `510`501`SELECT DISTINCT cellphone FROM contacts WHERE contacts.id='$rowid'`", _
"503`Fax: `511`501`SELECT DISTINCT fax FROM contacts WHERE contacts.id='$rowid'`", _
"503sss`Website: `512`501`SELECT DISTINCT website FROM contacts WHERE contacts.id='$rowid'`", _
"503`Notes: `513`501`SELECT DISTINCT notes FROM contacts WHERE contacts.id='$rowid'`", _
"503`Disabled: `514`501`SELECT DISTINCT disabled FROM contacts WHERE contacts.id='$rowid'`", _
"503`SQLMenu`603`501`SELECT equipment.id,('ID:'||equipment.id||', N:'||equipment.name||', '||(SELECT address.address FROM address WHERE equipment.addressid=address.id LIMIT 1)||', C:'||contacts.name) AS OUTPUT FROM equipment LEFT JOIN contacts ON contacts.id=equipment.contactid LEFT JOIN company ON company.id=contacts.companyid  WHERE equipment.contactid='$rowid' ORDER BY equipment.id DESC LIMIT 99`", _
"504`Enter Name: `503`503``UPDATE OR IGNORE contacts SET name='$typedtext' WHERE contacts.id='$rowid'", _
"505`Enter Position: `503`503``UPDATE OR IGNORE contacts SET title='$typedtext' WHERE contacts.id='$rowid'", _
"506`Search Address: `506a`506a``c", _
"506a`SQLMenu`506c`503`SELECT id,(address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE contacts SET addressid='$rowid' WHERE contacts.id='$pprowid'", _
"506b``506c`506c`SELECT '$prowid','$prowid'`", _
"506c`2`503`503``", _
"507`Search Company: `507a`507a``c", _
"507a`SQLMenu`507c`503`SELECT company.id,(company.name) AS OUTPUT FROM company WHERE company.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE contacts SET companyid='$rowid' WHERE contacts.id='$pprowid'", _
"507b``507c`507c`SELECT '$prowid','$prowid'`", _
"507c`2`503`503``", _
"508`Enter Email: `503`503``UPDATE OR IGNORE contacts SET email='$typedtext' WHERE contacts.id='$rowid'", _
"509`Enter Office Phone: `503`503``UPDATE OR IGNORE contacts SET officephone='$typedtext' WHERE contacts.id='$rowid'", _
"510`Enter Cell Phone: `503`503``UPDATE OR IGNORE contacts SET cellphone='$typedtext' WHERE contacts.id='$rowid'", _
"511`Enter Fax: `503`503``UPDATE OR IGNORE contacts SET fax='$typedtext' WHERE contacts.id='$rowid'", _
"512sss`Enter Website: `503`503``UPDATE OR IGNORE contacts SET website='$typedtext' WHERE contacts.id='$rowid'", _
"513`Enter Notes: `503`503``UPDATE OR IGNORE contacts SET notes='$typedtext' WHERE contacts.id='$rowid'", _
"514``503`503``UPDATE OR IGNORE contacts SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE contacts.id='$rowid'", _
"515`Must Enter Email Address: `503`503`SELECT contacts.id,contacts.id FROM contacts ORDER BY contacts.id DESC LIMIT 1`INSERT OR IGNORE INTO contacts(email,createdby,disabled) VALUES('$typedtext','$userid','0')", _
"516`Search Contact: `517`517``c", _
"517`SQLMenu`503`516`SELECT contacts.id,(contacts.name ||' '||company.name||' '||contacts.email ||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.name LIKE '%$rowid%' OR company.name LIKE '%$rowid%' OR contacts.email LIKE '%$rowid%' OR contacts.officephone LIKE '%$rowid%' OR contacts.cellphone LIKE '%$rowid%' LIMIT 14`", _
"601sss`List Some Prior Entered Equipment`602`100``", _
"601`Add Equipment`610`100``", _
"601`Find Equipment`611`100``", _
"601`Edit Equipment Type`613`100``", _
"601`SQLMenu`603`601`SELECT equipment.id,('ID:'||equipment.id||', N:'||equipment.name||', '||(SELECT address FROM address WHERE equipment.addressid=address.id LIMIT 1)||', C:'||(SELECT contacts.name FROM contacts WHERE equipment.contactid=contacts.id LIMIT 1)) AS OUTPUT FROM equipment ORDER BY equipment.id DESC LIMIT 14`", _
"603`Add Equipment`610`601``", _
"603`ID: `604`601`SELECT (''||equipment.id||' Name: '||equipment.name) AS A FROM equipment WHERE equipment.id='$rowid' LIMIT 1`", _
"603`Address: `605`601`SELECT address FROM address LEFT JOIN equipment ON equipment.addressid=address.id WHERE equipment.id='$rowid' LIMIT 1`", _
"603`Contact: `606`601`SELECT (contacts.name||', '||company.name) AS A FROM contacts LEFT JOIN equipment ON equipment.contactid=contacts.id LEFT JOIN company ON company.id=contacts.companyid WHERE equipment.id='$rowid' LIMIT 1`", _
"603`Equipment Type: `619`601`SELECT type.name FROM equipment LEFT JOIN type ON type.id=equipment.typeid WHERE equipment.id='$rowid'`", _
"603`Serial Number: `607`601`SELECT DISTINCT sn FROM equipment WHERE equipment.id='$rowid'`", _
"603`Notes: `608`601`SELECT DISTINCT notes FROM equipment WHERE equipment.id='$rowid'`", _
"603`Disabled: `609`601`SELECT DISTINCT disabled FROM equipment WHERE equipment.id='$rowid'`", _
"604`Enter Name: `603`603``UPDATE OR IGNORE equipment SET name='$typedtext' WHERE equipment.id='$rowid'", _
"605`Search Address: `605a`605a``c", _
"605a`SQLMenu`605b`603`SELECT id,(address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE equipment SET addressid='$rowid' WHERE equipment.id='$pprowid'", _
"605b`2`603`603``", _
"606`Search Contact: `606a`606a``c", _
"606a`SQLMenu`606b`603`SELECT contacts.id,(contacts.name ||' '||company.name||' '||contacts.email||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.name LIKE '%$rowid%' OR company.name LIKE '%$rowid%' OR contacts.email LIKE '%$rowid%' OR contacts.officephone LIKE '%$rowid%' OR contacts.cellphone LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE equipment SET contactid='$rowid' WHERE equipment.id='$pprowid'", _
"606b`2`603`603``", _
"607`Enter Serial: `603`603``UPDATE OR IGNORE equipment SET sn='$typedtext' WHERE equipment.id='$rowid'", _
"608`Enter Notes: `603`603``UPDATE OR IGNORE equipment SET notes='$typedtext' WHERE equipment.id='$rowid'", _
"609``603`603``UPDATE OR IGNORE equipment SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE equipment.id='$rowid'", _
"610`Enter Equipment ID Number: `603`603`SELECT equipment.id,equipment.id FROM equipment WHERE equipment.id='$typedtext' ORDER BY equipment.id DESC LIMIT 1`INSERT OR IGNORE INTO equipment(id,addressid,contactid,createdby,disabled) VALUES('$typedtext','1','1','$userid','0')", _
"611`Search Equipment: `612`612``c", _
"612`SQLMenu`603`601`SELECT equipment.id,(equipment.id ||' '||(SELECT address FROM address WHERE equipment.addressid=address.id LIMIT 1)||' '||equipment.name||' '||sn ||' ') AS OUTPUT FROM equipment LEFT JOIN contacts ON contacts.id=equipment.contactid LEFT JOIN company ON company.id=contacts.id WHERE equipment.id LIKE '%$rowid%' OR equipment.name LIKE '%$rowid%' OR equipment.sn LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%'OR company.name LIKE '%$rowid%'LIMIT 14`", _
"613`Add Equipment Type`621`601``", _
"613`SQLMenu`614`601`SELECT type.id,(type.billingcode ||': '||type.name||' '||type.hourlyrate||' '||type.travelrate) AS OUTPUT FROM type LIMIT 99`", _
"614`Add Equipment Type`621`601``", _
"614`Name: `615`601`SELECT type.name FROM type WHERE type.id='$rowid'`", _
"614`Hourly Rate: `616`601`SELECT type.hourlyrate FROM type WHERE type.id='$rowid'`", _
"614`Travel Rate: `617`601`SELECT type.travelrate FROM type WHERE type.id='$rowid'`", _
"614`Billing Code: `618`601`SELECT DISTINCT billingcode FROM type WHERE type.id='$rowid'`", _
"614`Disabled: `620`601`SELECT DISTINCT disabled FROM type WHERE type.id='$rowid'`", _
"615`Enter Name: `614`614``UPDATE OR IGNORE type SET name='$typedtext' WHERE type.id='$rowid'", _
"616`Enter Hourly Rate: `614`614``UPDATE OR IGNORE type SET hourlyrate='$typedtext' WHERE type.id='$rowid'", _
"617`Enter Travel Rate: `614`614``UPDATE OR IGNORE type SET travelrate='$typedtext' WHERE type.id='$rowid'", _
"618`Enter Short Billing Code: `614`614``UPDATE OR IGNORE type SET billingcode='$typedtext' WHERE type.id='$rowid'", _
"620``614`614``UPDATE OR IGNORE type SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE type.id='$rowid'", _
"621`Enter type Type Name: `614`614`SELECT type.id,type.id FROM type WHERE type.name='$typedtext' ORDER BY type.id DESC LIMIT 1`INSERT OR IGNORE INTO type(name,hourlyrate,travelrate,createdby,disabled) VALUES('$typedtext','1','1','$userid','0')", _
"619`SQLMenu`622`603`SELECT 0,'Leave Blank'`UPDATE OR IGNORE equipment SET typeid='' WHERE equipment.id='$prowid'", _
"619`SQLMenu`622`601`SELECT type.id,(type.billingcode ||': '||type.name||' '||type.hourlyrate||' '||type.travelrate) AS OUTPUT FROM type LIMIT 99`UPDATE OR IGNORE equipment SET typeid='$rowid' WHERE equipment.id='$prowid'", _
"622`1`603`603``", _
"701`Add Address`710`100``", _
"701`Find Address`715`100``", _
"701`SQLMenu`703`701`SELECT address.id,(''||address||', city:'||city||', state:'||state||', zip:'||zip||', country:'||country||', disabled:'||disabled) AS OUTPUT FROM address ORDER BY address.id DESC LIMIT 14`", _
"703`Address: `704`701`SELECT DISTINCT address FROM address WHERE address.id='$rowid'`", _
"703`City: `705`701`SELECT DISTINCT city FROM address WHERE address.id='$rowid'`", _
"703`State: `706`701`SELECT DISTINCT state FROM address WHERE address.id='$rowid'`", _
"703`Zip: `707`701`SELECT DISTINCT zip FROM address WHERE address.id='$rowid'`", _
"703`Country: `708`701`SELECT DISTINCT country FROM address WHERE address.id='$rowid'`", _
"703`Disabled: `709`701`SELECT DISTINCT disabled FROM address WHERE address.id='$rowid'`", _
"704`Enter Address: `703`703``UPDATE OR IGNORE address SET address='$typedtext' WHERE address.id='$rowid'", _
"705`Enter City: `703`703``UPDATE OR IGNORE address SET city='$typedtext' WHERE address.id='$rowid'", _
"706`Enter State: `703`703``UPDATE OR IGNORE address SET state=(CASE WHEN upper('$typedtext')='N/A' THEN '' WHEN length('$typedtext')>1 THEN upper('$typedtext') ELSE '' END) WHERE address.id='$rowid'", _
"707`Enter Zip: `703`703``UPDATE OR IGNORE address SET zip=replace(upper('$typedtext'),' ','') WHERE address.id='$rowid'", _
"708`Enter Country Code: `703`703``UPDATE OR IGNORE address SET country=upper('$typedtext') WHERE address.id='$rowid'", _
"709``703`703``UPDATE OR IGNORE address SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE address.id='$rowid'", _
"710`Enter Address: `711`711`SELECT address.id,address.id FROM address ORDER BY address.id DESC LIMIT 1`INSERT OR IGNORE INTO address(address,createdby,disabled) VALUES('$typedtext','$userid','0')", _
"711`Enter City: `712`712``UPDATE OR IGNORE address SET city='$typedtext' WHERE address.id='$rowid'", _
"712`Enter State: `713`713``UPDATE OR IGNORE address SET state=(CASE  WHEN upper('$typedtext')='N/A' THEN '' WHEN length('$typedtext')>1 THEN upper('$typedtext') THEN '' ELSE '' END) WHERE address.id='$rowid'", _
"713`Enter Zip: `714`714``UPDATE OR IGNORE address SET zip=replace(upper('$typedtext'),' ','') WHERE address.id='$rowid'", _
"714`Enter Country Code: `702`702``UPDATE OR IGNORE address SET country=upper('$typedtext') WHERE address.id='$rowid'", _
"715`Enter Address: `716`716``c", _
"716`SQLMenu`703`702`SELECT address.id,(address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`", _
"100`List Pending`904`100``", _
"100`List Dispatched`904a`100``", _
"100`List Closed`913`100``", _
"100`List Invoiced`904c`100``", _
"100`List Paid`904d`100``", _
"100`Inventory`801`101``", _
"801`Scan Inventory`815`100``", _
"815`SQLMenu`815a`801`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||char(10)) AS OUTPUT FROM user ORDER BY user.id DESC LIMIT 22`", _
"815a``816`816``UPDATE OR IGNORE user SET invid='';UPDATE OR IGNORE user SET invmode='D'", _
"815b``816`816`SELECT user.id,user.id FROM user WHERE user.id='$userid'`UPDATE OR IGNORE user SET invid='';UPDATE OR IGNORE user SET invmode='D'", _
"816`SELECTed User: `817`801`SELECT user.name FROM user WHERE user.id='$rowid'`", _
"816`Inventory Mode: `819`801`SELECT (CASE user.invmode WHEN 'D' THEN 'Deposit' ELSE 'Withdraw' END) AS A  FROM user WHERE user.id='$rowid'`", _
"816`SELECTed Part: `820`801`SELECT (user.invid||': '||inventory.name)AS A FROM user LEFT JOIN inventory ON inventory.id=user.invid WHERE user.id='$rowid'`", _
"816`Item Location: `816`801`SELECT shelf.name FROM user LEFT JOIN inventory ON inventory.id=user.invid LEFT JOIN shelf ON shelf.id=inventory.shelfid WHERE user.id='$rowid'`", _
"816`Item Quantity: `816`801`SELECT inventory.qty FROM user LEFT JOIN inventory ON inventory.id=user.invid WHERE user.id='$rowid'`", _
"816`Deposit `823`801``", _
"823``816`816``UPDATE OR IGNORE user SET invmode='D' WHERE user.id='$rowid';UPDATE OR IGNORE inventory SET qty=qty+1 WHERE inventory.id=(SELECT user.invid FROM user WHERE user.id='$rowid' LIMIT 1);UPDATE OR IGNORE userinv SET qty=qty-1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE userinv.userid='$rowid' AND userinv.inventoryid=(SELECT user.invid FROM user WHERE user.id='$rowid' LIMIT 1);DELETE FROM userinv WHERE userinv.qty='0' AND userinv.id IN(SELECT userinv.id FROM userinv LEFT JOIN user ON user.invid=userinv.inventoryid WHERE user.id='$rowid')", _
"816`Withdraw `824`801``", _
"824``816`816``UPDATE OR IGNORE user SET invmode='W' WHERE user.id='$rowid';UPDATE OR IGNORE userinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) WHERE userinv.userid='$rowid' AND userinv.inventoryid<>'' AND userinv.inventoryid=(SELECT user.invid FROM user LEFT JOIN inventory ON inventory.id=user.invid WHERE user.id='$rowid' AND inventory.qty>0 LIMIT 1);INSERT or IGNORE INTO userinv(inventoryid,userid,qty,date,notes,createdby,disabled) SELECT user.invid,'$rowid','1',STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'','$userid','0' FROM user WHERE user.id='$rowid' AND user.invid<>'' AND NOT EXISTS(SELECT userinv.inventoryid FROM userinv LEFT JOIN user ON user.invid=userinv.inventoryid WHERE userinv.userid='$rowid' AND userinv.inventoryid=USER.invid);UPDATE OR IGNORE inventory SET qty=qty-1 WHERE inventory.qty>0 AND inventory.id=(SELECT user.invid FROM user WHERE user.id='$rowid' LIMIT 1);", _
"816`SQLMenu`815a`801`SELECT user.id,(user.name||': '||inventory.id||' - '||inventory.name||', Qty:'||userinv.qty||', '||userinv.date) AS A FROM userinv LEFT JOIN user on userinv.userid=user.id LEFT JOIN inventory ON inventory.id=userinv.inventoryid WHERE inventory.shelfid>0 AND inventory.disabled=0 ORDER BY userinv.id DESC`", _
"816`bc`816`816`SELECT user.id  AS A FROM user WHERE user.invbarcode='$typedtext' UNION SELECT '$prowid' LIMIT 2`", _
"817`Search User: `818`818``c", _
"818`SQLMenu`825`816`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege) AS OUTPUT FROM user WHERE user.name LIKE '%$rowid%' OR login LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR phone LIKE '%$rowid%' OR fullname LIKE '%$rowid%' LIMIT 14`", _
"825``816`816``", _
"819``816`816``UPDATE OR IGNORE user SET invmode=CASE invmode WHEN 'D' THEN 'W' WHEN 'W' THEN 'D' END WHERE user.id='$rowid'", _
"820`Search Part: `821`821``c", _
"821`SQLMenu`822`816`SELECT inventory.id,(inventory.id||' '||inventory.name||' '||qty) AS OUTPUT FROM inventory WHERE inventory.id LIKE '%$rowid%' OR inventory.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE user SET invid='$rowid' WHERE user.id='$pprowid'", _
"822`2`816`816``", _
"801`Add to Inventory`803a`100``", _
"801`Find Inventory`810`100``", _
"801`SQLMenu`803`801`SELECT inventory.id,(''||inventory.id||', name:'||inventory.name||', shelf:'||(shelf.name)||', qty:'||qty) AS OUTPUT FROM inventory LEFT JOIN shelf ON shelf.id=inventory.shelfid WHERE inventory.shelfid>0 AND inventory.disabled=0 ORDER BY inventory.id DESC LIMIT 14`", _
"803a`Enter Barcode >(10000000): `803`803`SELECT '$typedtext','$typedtext'`INSERT OR IGNORE INTO inventory(id,name,shelfid,qty,notes,createdby,disabled) VALUES('$typedtext','','1','1','','$userid','0')", _
"803`Barcode: `804`801`SELECT DISTINCT inventory.id FROM inventory WHERE inventory.id='$rowid'`", _
"803`Name: `805`801`SELECT DISTINCT inventory.name FROM inventory WHERE inventory.id='$rowid'`", _
"803`Shelf: `806`801`SELECT shelf.name FROM shelf LEFT JOIN inventory ON inventory.shelfid=shelf.id WHERE inventory.id='$rowid' LIMIT 1`", _
"803`Qty: `813`801`SELECT inventory.qty FROM inventory WHERE inventory.id='$rowid' LIMIT 1`", _
"803`Cost: `814`801`SELECT DISTINCT ('$'||printf('%.2f',inventory.cost)) AS A FROM inventory WHERE inventory.id='$rowid'`", _
"803`Supplier: `826`801`SELECT DISTINCT (char(13)||char(10)||'    '||company.name||char(13)||char(10)||'    '||address.address||char(13)||char(10)||'    '||company.officephone||char(13)||char(10)||'    '||company.email) AS A FROM inventory LEFT JOIN company ON company.id=inventory.supplierid LEFT JOIN address ON address.id=company.id WHERE inventory.id='$rowid'`", _
"803`Supplier Part Number: `829`801`SELECT DISTINCT inventory.supplierpartnumber FROM inventory WHERE inventory.id='$rowid'`", _
"803`Price: `830`801`SELECT DISTINCT ('$'||printf('%.2f',inventory.price)) AS A FROM inventory WHERE inventory.id='$rowid'`", _
"803`Charge Tax: `831`801`SELECT (CASE inventory.plustax WHEN '1' THEN 'YES' ELSE 'NO' END) AS A FROM inventory WHERE inventory.id='$rowid' LIMIT 1``", _
"803`Notes: `808`801`SELECT DISTINCT inventory.notes FROM inventory WHERE inventory.id='$rowid'`", _
"803`Created by: `803`801`SELECT (user.name||', '||'U'||PRINTF('%01d',inventory.createdby)) AS A FROM inventory LEFT JOIN user on user.id=inventory.createdby WHERE inventory.id='$rowid'`", _
"803`Disabled: `809`801`SELECT DISTINCT disabled FROM inventory WHERE inventory.id='$rowid'`", _
"804`Enter Barcode: `803`803`SELECT '$typedtext','$typedtext'`UPDATE OR IGNORE inventory SET id='$typedtext' WHERE id<>'' AND inventory.id='$rowid' AND NOT EXISTS (SELECT userinv.inventoryid FROM userinv WHERE userinv.inventoryid='$rowid')", _
"805`Enter Item Name: `803`803``UPDATE OR IGNORE inventory SET name='$typedtext' WHERE inventory.id='$rowid'", _
"806`Add New Shelf`806b`803``", _
"806b`Enter Shelf Name: `806`806`SELECT '$typedtext','$typedtext'`INSERT OR IGNORE INTO shelf(name,barcode) VALUES('$typedtext',abs(random() % 9000))", _
"806`SQLMenu`807`803`SELECT shelf.id,shelf.name FROM shelf`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$prowid'", _
"807`1`803`803``", _
"826`Search Company Name: `827`827``c", _
"827`SQLMenu`828`826`SELECT company.id,(company.name ||' '||company.email ||' '||company.officephone||' '||company.cellphone) AS OUTPUT FROM company WHERE company.name LIKE '%$rowid%' OR company.email LIKE '%$rowid%' OR company.officephone LIKE '%$rowid%' OR company.cellphone LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET supplierid='$rowid' WHERE inventory.id='$pprowid'", _
"828`2`803`803``", _
"829`Enter Supplier Part Number: `803`803``UPDATE OR IGNORE inventory SET supplierpartnumber='$typedtext' WHERE inventory.id='$rowid'", _
"830`Enter Price: `803`803``UPDATE OR IGNORE inventory SET price='$typedtext' WHERE inventory.id='$rowid'", _
"831``803`803``UPDATE OR IGNORE inventory SET plustax=CASE plustax WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE inventory.id='$rowid'", _
"810`Search Item: `810a`810a``c", _
"810a`SQLMenu`803`801`SELECT inventory.id,(inventory.name||' ') AS OUTPUT FROM inventory WHERE inventory.id LIKE '%$rowid%' OR inventory.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$pprowid'", _
"806ss`Search Contact: `806a`806a``c", _
"806a`SQLMenu`803`801`SELECT contacts.id,(contacts.name ||' '||company.name||' '||user.email||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.name LIKE '%$rowid%' OR company.name LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR contacts.officephone LIKE '%$rowid%' OR contacts.cell LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET contactid='$rowid' WHERE inventory.id='$pprowid'", _
"807ss`Enter Serial: `803`803``UPDATE OR IGNORE inventory SET sn='$typedtext' WHERE inventory.id='$rowid'", _
"808`Enter Notes: `803`803``UPDATE OR IGNORE inventory SET notes='$typedtext' WHERE inventory.id='$rowid'", _
"809d``803`803``UPDATE OR IGNORE inventory SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE  inventory.id='$rowid'", _
"809``803`803``UPDATE OR IGNORE inventory SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE inventory.id='$rowid'", _
"811`Search inventory: `812`812``c", _
"812`SQLMenu`803`801`SELECT inventory.id,(inventory.id ||' '||(SELECT shelf FROM shelf WHERE inventory.shelfid=shelf.id LIMIT 1)||' '||inventory.name||' '||sn ||' ') AS OUTPUT FROM inventory WHERE inventory.id LIKE '%$rowid%' OR inventory.name LIKE '%$rowid%' OR sn LIKE '%$rowid%' LIMIT 14`", _
"813`UPDATE OR IGNORE Total Quantity: `803`803``UPDATE OR IGNORE inventory SET qty='$typedtext' WHERE inventory.id='$rowid'", _
"814`UPDATE OR IGNORE Cost: `803`803``UPDATE OR IGNORE inventory SET cost='$typedtext' WHERE inventory.id='$rowid'", _
"904`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch LEFT JOIN address ON dispatch.addressid=address.id WHERE dispatch.status='1' ORDER BY dispatch.id DESC LIMIT 55`", _
"904a`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch LEFT JOIN address ON dispatch.addressid=address.id WHERE dispatch.status='2' ORDER BY dispatch.id DESC LIMIT 55`", _
"904b`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch LEFT JOIN address ON dispatch.addressid=address.id WHERE dispatch.status='3' ORDER BY dispatch.id DESC LIMIT 14`", _
"904c`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch LEFT JOIN address ON dispatch.addressid=address.id WHERE dispatch.status='4' ORDER BY dispatch.id DESC LIMIT 14`", _
"904d`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' id:'||equipmentid||' address:'||address.address||' date:'||date||' p:'||contact||' by:'||reportedby||' dispatched:'||(SELECT ifnull(group_concat(DISTINCT user.name),'') as name FROM servicecall LEFT JOIN user ON servicecall.userid=user.id WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' ORDER BY name ASC)) AS OUTPUT FROM dispatch LEFT JOIN address ON dispatch.addressid=address.id WHERE dispatch.status='5' ORDER BY dispatch.id DESC LIMIT 14`", _
"905`Enter Equipment ID: `905a`905a``c", _
"905a`SQLMenu`905b`100`SELECT DISTINCT equipment.id, (equipment.id||' '||equipment.name||' sn:'||equipment.sn||' notes:'||equipment.notes) AS OUTPUT FROM equipment WHERE equipment.id='$rowid'`", _
"905b`Enter Reported Issue:`906`906`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes) AS OUTPUT  FROM dispatch ORDER BY dispatch.id DESC LIMIT 1 `INSERT OR IGNORE INTO dispatch(equipmentid,addressid,contactid,date,contracttype,reportedissue,hourlyrate,travelrate,status,createdby,disabled) VALUES('$rowid',(SELECT addressid FROM equipment where equipment.id='$rowid'),(SELECT contactid FROM equipment where equipment.id='$rowid'),STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),(SELECT ifnull((SELECT quote.contracttype FROM equipment LEFT JOIN quote,qtscope ON (quote.contactid=equipment.contactid AND quote.startdate<=strftime('%Y%m%d',date('now')) AND quote.enddate>=strftime('%Y%m%d',date('now')) AND qtscope.qtid=quote.id AND qtscope.typeid=equipment.typeid) LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid' GROUP by quote.contracttype),0)),'$typedtext',(SELECT type.hourlyrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),(SELECT type.travelrate FROM equipment LEFT JOIN type ON equipment.typeid=type.id WHERE equipment.id='$rowid'),'1','$userid','0')", _
"906`Dispatch: `906`100`SELECT DISTINCT dispatch.id FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Equipment ID: `907`100`SELECT DISTINCT dispatch.equipmentid FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Reported Date: `906`100`SELECT DISTINCT (substr(dispatch.date,1,4)||'-'||substr(dispatch.date,5,2)||'-'||substr(dispatch.date,7,2)||' '||substr(dispatch.date,9,2)||':'||substr(dispatch.date,11,2)) FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Reported Issue: `909`100`SELECT DISTINCT dispatch.reportedissue FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Reported By: `910`100`SELECT DISTINCT dispatch.reportedby FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Reported Contact: `911`100`SELECT DISTINCT dispatch.contact FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Notes: `912`100`SELECT DISTINCT dispatch.notes FROM dispatch WHERE dispatch.id='$rowid'`", _
"906`Add User to Dispatch `915`100``", _
"906`SQLMenu`917`906`SELECT servicecall.id, (user.name ||' '||substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) ||' '||servicecall.starttime ||' h:'||servicecall.time ||' t:'||servicecall.traveltime) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id=servicecall.userid WHERE dispatchid='$rowid' AND servicecall.disabled='0' ORDER BY servicecall.date DESC`", _
"906`Status: `914`100`SELECT DISTINCT (dispatch.status ||' '||status.status) AS OUTPUT FROM dispatch LEFT JOIN status ON status.id=dispatch.status WHERE dispatch.id='$rowid'`", _
"907`Enter Equipment: `906`906``UPDATE OR IGNORE dispatch SET equipmentid='$typedtext' WHERE dispatch.id='$rowid'", _
"908`Enter Date: `906`906``UPDATE OR IGNORE dispatch SET date=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE dispatch.id='$rowid'", _
"909`Enter Issue: `906`906``UPDATE OR IGNORE dispatch SET reportedissue='$typedtext' WHERE dispatch.id='$rowid'", _
"910`Enter Person who called in: `906`906``UPDATE OR IGNORE dispatch SET reportedby='$typedtext' WHERE dispatch.id='$rowid'", _
"911`Enter Phone: `906`906``UPDATE OR IGNORE dispatch SET contact='$typedtext' WHERE dispatch.id='$rowid'", _
"912`Enter Notes: `906`906``UPDATE OR IGNORE dispatch SET notes='$typedtext' WHERE dispatch.id='$rowid'", _
"913`Search Dispatch: `913a`913a``c", _
"913a`SQLMenu`906`100`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes) AS OUTPUT FROM dispatch WHERE dispatch.status='3' AND (dispatch.id LIKE '%$rowid%' OR equipmentid LIKE '%$rowid%' OR reportedissue LIKE '%$rowid%' OR reportedby LIKE '%$rowid%' OR contact LIKE '%$rowid%') LIMIT 14`", _
"915`Enter Dispatched User: `916`916``c", _
"916`SQLMenu`917b`100`SELECT user.id,('id:'||user.id||' login:'||login||' name:'||user.name||' fullname:'||fullname||' p:'||phone||' e:'||user.email||' '||privilege) AS OUTPUT FROM user WHERE user.name LIKE '%$rowid%' OR login LIKE '%$rowid%' OR fullname LIKE '%$rowid%' OR user.email LIKE '%$rowid%' OR phone LIKE '%$rowid%' LIMIT 14`", _
"917b`Enter Onsite Date:`906`906`SELECT dispatch.id,(dispatch.id||' '||equipmentid||' '||reportedby||' '||reportedissue||' '||contact||' '||notes) AS OUTPUT FROM dispatch WHERE dispatch.id='$pprowid'`INSERT OR IGNORE INTO servicecall(dispatchid,userid,date,createdby,disabled) VALUES('$pprowid','$rowid',replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':',''),'$userid','0');UPDATE OR IGNORE dispatch SET status='2' WHERE dispatch.id='$pprowid'", _
"f917b`SQLMenu`917`100`SELECT servicecall.id,servicecall.id FROM servicecall ORDER BY servicecall.id DESC LIMIT 1`", _
"914`Enter Status: `906`906``UPDATE OR IGNORE dispatch SET status='$typedtext' WHERE dispatch.id='$rowid'", _
"917`User: `923`906`SELECT DISTINCT (user.name ||' id: '||servicecall.userid) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Date: `924`906`SELECT DISTINCT substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Arrival: `925`906`SELECT DISTINCT servicecall.starttime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Work Hours: `926`906`SELECT DISTINCT servicecall.time FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Travel Hours: `927`906`SELECT DISTINCT servicecall.traveltime FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Solution: `928`906`SELECT DISTINCT replace(servicecall.solution,char(10),char(13)||char(10)) FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"917`Disabled: `929`906`SELECT DISTINCT servicecall.disabled FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON contacts.id = dispatch.contactid WHERE servicecall.id='$rowid'`", _
"923`Enter User`917`917``UPDATE OR IGNORE servicecall SET userid='$typedtext' WHERE servicecall.id='$rowid'", _
"924`Enter Date`917`917``UPDATE OR IGNORE servicecall SET date=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE servicecall.id='$rowid'", _
"925`Enter Arrival`917`917``UPDATE OR IGNORE servicecall SET starttime=(SELECT (CASE length('$typedtext') WHEN 4 THEN '0'||'$typedtext' ELSE '$typedtext' END)) WHERE servicecall.id='$rowid'", _
"926`Enter Work Hours`917`917``UPDATE OR IGNORE servicecall SET time='$typedtext' WHERE servicecall.id='$rowid'", _
"927`Enter Travel Hours`917`917``UPDATE OR IGNORE servicecall SET traveltime='$typedtext' WHERE servicecall.id='$rowid';UPDATE servicecall SET travelprice=(SELECT dispatch.travelrate*servicecall.traveltime FROM servicecall LEFT JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.id=$rowid) WHERE servicecall.id=$rowid", _
"928`Enter Solution`917`917``UPDATE OR IGNORE servicecall SET solution='$typedtext' WHERE servicecall.id='$rowid'", _
"929``917`917``UPDATE OR IGNORE servicecall SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE servicecall.id='$rowid';UPDATE OR IGNORE dispatch SET status='1' WHERE dispatch.id in(SELECT servicecall.dispatchid FROM servicecall WHERE servicecall.id='$rowid' LIMIT 1) AND NOT EXISTS (SELECT servicecall.userid FROM servicecall WHERE servicecall.dispatchid=dispatch.id AND servicecall.disabled='0' LIMIT 1)", _
"100`Forms`A02`101``", _
"A02`Create New Form`A01`100``", _
"A01`Enter Form Name`A02`A02``INSERT OR IGNORE INTO formfieldtitle(name,disabled) VALUES('$typedtext','0');INSERT OR IGNORE INTO formfields(fgrp,fieldname) SELECT MAX(id),formfieldtitle.name FROM formfieldtitle", _
"A02`SQLMenu`A03`100`SELECT DISTINCT formfieldtitle.id AS ids,formfieldtitle.name||': '||(SELECT  ifnull(group_concat(DISTINCT formfields.fieldname) ,'') as name FROM (SELECT * FROM formfieldtitle INNER JOIN formfields ON formfields.fgrp=formfieldtitle.id) INNER JOIN formfields ON formfields.fgrp=formfieldtitle.id ) as A FROM formfieldtitle INNER JOIN formfields ON formfields.fgrp=formfieldtitle.id WHERE formfields.fgrp=formfieldtitle.id`", _
"A03`Add Field`A03b`A02``", _
"A03`Disabled: `A03c`A02`SELECT formfieldtitle.disabled FROM formfieldtitle WHERE formfieldtitle.id='$rowid' LIMIT 1`", _
"A03b`Enter Fieldname`A03`A03``INSERT OR IGNORE INTO formfields(fgrp,fieldname) VALUES('$rowid','$typedtext')", _
"A03c``A03`A03``UPDATE OR IGNORE formfieldtitle SET disabled=CASE disabled WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE formfieldtitle.id='$rowid'", _
"A03`SQLMenu`A04`A02`SELECT DISTINCT formfields.id,(formfields.fieldname) AS A FROM formfields LEFT JOIN scf ON  scf.scfcolid=formfields.id WHERE formfields.fgrp='$rowid' LIMIT 99`", _
"A04`Enter Form`A05`A05``UPDATE OR IGNORE formfields SET fieldname='$typedtext' WHERE formfields.id='$rowid'", _
"A05`1`A03`A03``", _
"100`Sales Dashboard`S00`100``", _
"S00`SQLMenu`Q03`100`SELECT DISTINCT quote.id,('Q'||PRINTF('%04d',quote.id)||', '||quote.quotedesc||', C'||PRINTF('%03d',quote.contactid)||', '||': '||company.name||': '||contacts.name||', '||contacts.email||', '||contacts.cellphone) as A FROM quote LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE quote.status<2 AND quote.createdby='$userid' ORDER BY quote.id DESC LIMIT 5`", _
"S00`Find Quote`S29`100``", _
"S29`Enter Quote Search Terms: `S30`S30``c", _
"S30`SQLMenu`Q03`S00`SELECT DISTINCT quote.id, (PRINTF('Q%07d',quote.id)||' '||quote.quotedesc||' '||quote.sitename||' '||ifnull(address.address,'')||' '||contacts.name||' '||company.name||char(10)) AS OUTPUT FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%' OR address.city LIKE '%$rowid%' OR address.zip LIKE '%$rowid%' OR address.country LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.address LIKE '%$rowid%' OR quote.sitename LIKE '%$rowid%' OR quote.quotedesc LIKE '%$rowid%' OR quote.id LIKE '%$rowid%' ORDER BY quote.id DESC LIMIT 14`", _
"S00`New Quote`Q00`100``", _
"S00`SQLMenu`O03`100`SELECT DISTINCT packingslip.id,('PS'||PRINTF('%04d',packingslip.id)||', '||quote.quotedesc||', C'||PRINTF('%03d',quote.contactid)||', '||': '||company.name||': '||contacts.name) as A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE quote.createdby='$userid' ORDER BY packingslip.id DESC LIMIT 5`", _
"S00`New Packing Slip`O00`100``", _
"O00`Enter Quote Search Terms: `O01`O01``c", _
"O01`SQLMenu`O03`S00`SELECT DISTINCT quote.id, (PRINTF('Q%07d',quote.id)||' '||quote.quotedesc||' '||quote.sitename||' '||ifnull(address.address,'')||' '||contacts.name||' '||company.name||char(10)) AS OUTPUT FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%' OR address.city LIKE '%$rowid%' OR address.zip LIKE '%$rowid%' OR address.country LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.address LIKE '%$rowid%' OR quote.sitename LIKE '%$rowid%' OR quote.quotedesc LIKE '%$rowid%' OR quote.id LIKE '%$rowid%' ORDER BY quote.id DESC LIMIT 14`INSERT or IGNORE INTO packingslip(qtid,date,createdby,notes) SELECT id AS qtid,STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'$userid',('Based on Quote: '||PRINTF('Q%07d',quote.id)) as A FROM quote WHERE quote.id='$rowid' LIMIT 1;UPDATE OR IGNORE quote SET status=3 WHERE quote.id='$rowid'", _
"O03`Description: `O03`S00`SELECT quote.quotedesc FROM quote LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03``O03`S00`SELECT ('Packing Slip: '||PRINTF('PS%06d',packingslip.id)||', Quote: '||PRINTF('Q%07d',quote.id)||', ContactID:'||quote.contactid) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`SQLMenu`O03`S00`SELECT '$rowid','Create Packing Slip' as A WHERE NOT EXISTS(SELECT '' FROM packingslip WHERE packingslip.qtid='$rowid')`INSERT or IGNORE INTO packingslip(qtid,notes) SELECT id AS qtid,('Based on Quote: '||PRINTF('Q%07d',quote.id)) as A FROM quote LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1;UPDATE OR IGNORE quote SET status=3 WHERE quote.id='$rowid'", _
"O03`SQLMenu`O03`S00`SELECT packingslip.qtid,('PS: '||PRINTF('Q%06d',packingslip.qtid)) AS A FROM packingslip WHERE packingslip.qtid='$rowid' LIMIT 1`", _
"O03`Contact Company: `O03`S00`SELECT (company.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Contact Name: `O03`S00`SELECT (contacts.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Contact Email: `O03`S00`SELECT (contacts.email) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Contact Phone: `O03`S00`SELECT (contacts.cellphone) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Date: `O03`S00`SELECT packingslip.date FROM packingslip WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Contract Type: `O03`S00`SELECT contracttype.title FROM quote LEFT JOIN contracttype ON contracttype.id=quote.contracttype LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Billing Address: `O03`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Site Name: `O03`S00`SELECT quote.sitename FROM quote LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`Site Address: `O03`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.state||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid' LIMIT 1`", _
"O03`SQLMenu`O03`S00`SELECT qtinv.id,(inventory.name||', Qty:'||qtinv.qty||' - Item'||inventory.id) AS A FROM qtinv LEFT JOIN packingslip ON packingslip.qtid=qtinv.qtid LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE packingslip.id='$rowid' ORDER BY qtinv.id DESC`", _
"O03`Notes: `O04`S00`SELECT packingslip.notes FROM packingslip WHERE packingslip.id='$rowid' LIMIT 1`", _
"O04`Enter Notes: `O03`O03``UPDATE OR IGNORE packingslip SET notes='$typedtext' WHERE packingslip.id='$rowid'", _
"O03`Created by: `O03`S00`SELECT (user.name||', '||'U'||PRINTF('%01d',quote.createdby)) AS A FROM quote LEFT JOIN user on user.id=quote.createdby LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid'`", _
"O03`Status: `O03`S00`SELECT status.status FROM quote LEFT JOIN status ON status.id=quote.status LEFT JOIN packingslip ON packingslip.qtid=quote.id WHERE packingslip.id='$rowid'`", _
"O03`Email Packing Slip`O05`S00``", _
"O03`Generate PDF `O05`S00``", _
"O03`Email to Self `O05`S00``", _
"O03`Email to Quote Creator `O05`S00``", _
"O05`psreport`O03```c", _
"S00`SQLMenu`I03`100`SELECT DISTINCT invoice.id,('I'||PRINTF('%04d',invoice.id)||', '||quote.quotedesc||', C'||PRINTF('%03d',quote.contactid)||', '||': '||company.name||': '||contacts.name) as A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE quote.createdby='$userid' ORDER BY invoice.id DESC LIMIT 5`", _
"S00`Find Invoice`S31`100``", _
"S31`Enter Invoice Search Terms: `S32`S32``c", _
"S32`SQLMenu`I03`S00`SELECT DISTINCT invoice.id, (PRINTF('I%07d',invoice.id)||' '||PRINTF('Q%07d',quote.id)||' '||quote.quotedesc||' '||quote.sitename||' '||ifnull(address.address,'')||' '||contacts.name||' '||company.name||char(10)) AS OUTPUT FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%' OR address.city LIKE '%$rowid%' OR address.zip LIKE '%$rowid%' OR address.country LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.address LIKE '%$rowid%' OR quote.sitename LIKE '%$rowid%' OR quote.quotedesc LIKE '%$rowid%' OR invoice.notes LIKE '%$rowid%' OR invoice.id LIKE '%$rowid%' ORDER BY quote.id DESC LIMIT 14`", _
"S00`New Invoice`I00`100``", _
"I00`Enter Quote Search Terms: `I01`I01``c", _
"I01`SQLMenu`I07`S00`SELECT DISTINCT quote.id, (PRINTF('Q%07d',quote.id)||' '||quote.quotedesc||' '||quote.sitename||' '||ifnull(address.address,'')||' '||contacts.name||' '||company.name||char(10)) AS OUTPUT FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%' OR address.city LIKE '%$rowid%' OR address.zip LIKE '%$rowid%' OR address.country LIKE '%$rowid%' OR address.state LIKE '%$rowid%' OR address.address LIKE '%$rowid%' OR quote.sitename LIKE '%$rowid%' OR quote.quotedesc LIKE '%$rowid%' OR quote.id LIKE '%$rowid%' ORDER BY quote.id DESC LIMIT 14`INSERT or IGNORE INTO invoice(qtid,date,createdby,notes) SELECT id AS qtid,STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'$userid',('Based on Quote: '||PRINTF('Q%07d',quote.id)) as A FROM quote WHERE quote.id='$rowid' LIMIT 1;UPDATE OR IGNORE quote SET status=3 WHERE quote.id='$rowid'", _
"I07``I03`I03`SELECT invoice.id,invoice.id FROM invoice ORDER BY invoice.id DESC LIMIT 1`", _
"I03`Description: `I06`S00`SELECT invoice.desc FROM invoice WHERE invoice.id='$rowid' LIMIT 1`", _
"I06`Enter Description Title text: `I03`I03``UPDATE OR IGNORE invoice SET desc='$typedtext' WHERE invoice.id='$rowid'", _
"I03``I03`S00`SELECT ('Invoice: '||PRINTF('I%08d',invoice.id)||', Quote: '||PRINTF('Q%07d',quote.id)||', ContactID:'||quote.contactid) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`SQLMenu`I03`S00`SELECT invoice.qtid,('I: '||PRINTF('Q%07d',invoice.qtid)) AS A FROM invoice WHERE invoice.qtid='$rowid' LIMIT 1`", _
"I03`Subtotal: `I03`S00`SELECT ((CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.subtotal)||' ('||(CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.total)||' Total)') AS A FROM quote LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Contact Company: `I03`S00`SELECT (company.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Contact Name: `I03`S00`SELECT (contacts.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Contact Email: `I03`S00`SELECT (contacts.email) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Contact Phone: `I03`S00`SELECT (contacts.cellphone) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Date: `I03`S00`SELECT DISTINCT (substr(invoice.date,1,4)||'-'||substr(invoice.date,5,2)||'-'||substr(invoice.date,7,2)||' '||substr(invoice.date,9,2)||':'||substr(invoice.date,11,2)) FROM invoice WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Contract Type: `I03`S00`SELECT contracttype.title FROM quote LEFT JOIN contracttype ON contracttype.id=quote.contracttype LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Billing Address: `I03`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Site Name: `I03`S00`SELECT quote.sitename FROM quote LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`Site Address: `I03`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.state||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid' LIMIT 1`", _
"I03`SQLMenu`I03`S00`SELECT qtinv.id,(inventory.name||', Qty:'||qtinv.qty||' - Item'||inventory.id) AS A FROM qtinv LEFT JOIN invoice ON invoice.qtid=qtinv.qtid LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE invoice.id='$rowid' ORDER BY qtinv.id DESC`", _
"I03`Notes: `I04`S00`SELECT invoice.notes FROM invoice WHERE invoice.id='$rowid' LIMIT 1`", _
"I04`Enter Notes: `I03`I03``UPDATE OR IGNORE invoice SET notes='$typedtext' WHERE invoice.id='$rowid'", _
"I03`Created by: `I03`S00`SELECT (user.name||', '||'U'||PRINTF('%01d',quote.createdby)) AS A FROM quote LEFT JOIN user on user.id=quote.createdby LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid'`", _
"I03`Status: `I03`S00`SELECT status.status FROM quote LEFT JOIN status ON status.id=quote.status LEFT JOIN invoice ON invoice.qtid=quote.id WHERE invoice.id='$rowid'`", _
"I03`Email Invoice`I05`S00``", _
"I03`Generate PDF `I05`S00``", _
"I03`Email to Self `I05`S00``", _
"I03`Email to Quote Creator `I05`S00``", _
"I05`invoice`I03`S00``c", _
"S00`New Purchase Order`S00`100``", _
"S00`New Receipt`S00`100``", _
"S00`Edit Terms`T01`100``", _
"S00`Add to Sales Inventory`S11`100``", _
"S00`Find in Sales Inventory`S16`100``", _
"S00`SQLMenu`S10`100`SELECT inventory.id,('Item'||inventory.id||':'||inventory.name||', qty:'||qty) AS OUTPUT FROM inventory LEFT JOIN shelf ON shelf.id=inventory.shelfid WHERE disabled='0' AND inventory.shelfid='0' ORDER BY PRINTF('%03d',inventory.id) DESC LIMIT 14`", _
"S11`Enter Sales Item Name: `S10`S10`SELECT DISTINCT inventory.id,inventory.id FROM inventory WHERE inventory.name='$typedtext'`UPDATE OR IGNORE sqlite_sequence SET seq=seq+1 WHERE name='salesinventoryid';INSERT OR IGNORE INTO inventory(id,name,shelfid,qty,notes,createdby,disabled) VALUES((SELECT seq FROM sqlite_sequence WHERE name='salesinventoryid' LIMIT 1),'$typedtext','0','0','','$userid','0')", _
"S10`Item`S10`S00`SELECT DISTINCT inventory.id FROM inventory WHERE inventory.id='$rowid'`", _
"S10`Name: `S13`S00`SELECT DISTINCT inventory.name FROM inventory WHERE inventory.id='$rowid'`", _
"S10`Location: `S14`S00`SELECT shelf.name FROM shelf LEFT JOIN inventory ON inventory.shelfid=shelf.id WHERE inventory.id='$rowid' LIMIT 1`", _
"S10`Qty: `S18`S00`SELECT inventory.qty FROM inventory WHERE inventory.id='$rowid' LIMIT 1`", _
"S10`Cost: `S19`S00`SELECT DISTINCT inventory.cost FROM inventory WHERE inventory.id='$rowid'`", _
"S10`Price: `S20`S00`SELECT DISTINCT inventory.price FROM inventory WHERE inventory.id='$rowid'`", _
"S10`Supplier: `S26`S00`SELECT DISTINCT (company.name||', '||company.email||', '||company.officephone) AS A FROM inventory LEFT JOIN company ON company.id=inventory.supplierid WHERE inventory.id='$rowid'`", _
"S10`Charge Tax: `S22`S00`SELECT DISTINCT inventory.plustax FROM inventory WHERE inventory.id='$rowid'`", _
"S10`Notes: `S23`S00`SELECT DISTINCT replace(inventory.notes,char(10),char(13)||char(10)) FROM inventory WHERE inventory.id='$rowid'`", _
"S23`Enter notes`S24`S24``UPDATE OR IGNORE inventory SET notes='$typedtext' WHERE inventory.id='$rowid'", _
"S24`ml`S24`S25`SELECT replace(inventory.notes,char(10),char(13)||char(10)),inventory.notes FROM inventory WHERE inventory.id='$rowid'`UPDATE OR IGNORE inventory SET notes=(SELECT DISTINCT inventory.notes FROM inventory WHERE inventory.id='$rowid')||'$typedtext'||char(10) WHERE inventory.id='$rowid'", _
"S25``S10`S10``UPDATE OR IGNORE inventory SET notes=(SELECT DISTINCT trim(inventory.notes,char(10)) FROM inventory WHERE inventory.id='$rowid') WHERE inventory.id='$rowid'", _
"S10`Created by: `S10`S00`SELECT (user.name||', '||'U'||PRINTF('%01d',terms.createdby)) AS A FROM terms LEFT JOIN user on user.id=terms.createdby WHERE terms.id='$rowid'`", _
"S10`Disabled: `S17`S00`SELECT DISTINCT disabled FROM inventory WHERE inventory.id='$rowid'`", _
"S13`Enter Item Name: `S10`S10``UPDATE OR IGNORE inventory SET name='$typedtext' WHERE inventory.id='$rowid'", _
"S14`Add New Shelf`S14b`S10``", _
"S14b`Enter Shelf Name: `S14`S14`SELECT '$typedtext','$typedtext'`INSERT OR IGNORE INTO shelf(name,barcode) VALUES('$typedtext',abs(random() % 9000))", _
"S14`SQLMenu`S15`S10`SELECT shelf.id,shelf.name FROM shelf`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$prowid'", _
"S15`1`S10`S10``", _
"S16`Search Item: `S17`S17``c", _
"S17`SQLMenu`S10`S00`SELECT inventory.id,(inventory.name||' ') AS OUTPUT FROM inventory WHERE inventory.id LIKE '%$rowid%' OR inventory.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET shelfid='$rowid' WHERE inventory.id='$pprowid'", _
"S18`UPDATE OR IGNORE Total Quantity: `S10`S10``UPDATE OR IGNORE inventory SET qty='$typedtext' WHERE inventory.id='$rowid'", _
"S19`UPDATE OR IGNORE Cost: `S10`S10``UPDATE OR IGNORE inventory SET cost='$typedtext' WHERE inventory.id='$rowid'", _
"S20`UPDATE OR IGNORE Price: `S10`S10``UPDATE OR IGNORE inventory SET price='$typedtext' WHERE inventory.id='$rowid'", _
"S22`UPDATE OR IGNORE Plustax: `S10`S10``UPDATE OR IGNORE inventory SET plustax='$typedtext' WHERE inventory.id='$rowid'", _
"S26`Search Company Name: `S27`S27``c", _
"S27`SQLMenu`S28`S00`SELECT company.id,(company.name ||' '||company.email ||' '||company.officephone||' '||company.cellphone) AS OUTPUT FROM company WHERE company.name LIKE '%$rowid%' OR company.email LIKE '%$rowid%' OR company.officephone LIKE '%$rowid%' OR company.cellphone LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE inventory SET supplierid='$rowid' WHERE inventory.id='$pprowid'", _
"S28`2`S10`S10``", _
"T01`Add terms`T02`100``", _
"T01`Find terms`T08`100``", _
"T02`Enter Title: `T03`T03`SELECT terms.id,terms.id FROM terms ORDER BY terms.id DESC LIMIT 1`INSERT OR IGNORE INTO terms(title,createdby) VALUES('$typedtext','$userid')", _
"T01`SQLMenu`T03`T01`SELECT terms.id,('T'||PRINTF('%02d',terms.id)||': '||title) AS A FROM terms ORDER BY terms.id DESC LIMIT 14`", _
"T03`ID: `T03`T01`SELECT $rowid,$rowid LIMIT 1`", _
"T03`Title: `T04`T01`SELECT DISTINCT title FROM terms WHERE terms.id='$rowid' LIMIT 1`", _
"T03`Description:`T05`T01`SELECT (char(13)||char(10)||'    '||replace(terms.desc,char(10),char(13)||char(10)||'    ')) FROM terms WHERE terms.id='$rowid'`", _
"T03`Created by: `T03`T01`SELECT (user.name||', '||'U'||PRINTF('%01d',terms.createdby)) AS A FROM terms LEFT JOIN user on user.id=terms.createdby WHERE terms.id='$rowid'`", _
"T04`Enter Title: `T03`T03``UPDATE OR IGNORE terms SET title='$typedtext' WHERE terms.id='$rowid'", _
"T05`Enter Agreement Term Text: `T06`T06``UPDATE OR IGNORE terms SET desc='$typedtext' WHERE terms.id='$rowid'", _
"T06`ml`T06`T07`SELECT replace(terms.desc,char(10),char(13)||char(10)),terms.desc FROM terms WHERE terms.id='$rowid'`UPDATE OR IGNORE terms SET desc=(SELECT DISTINCT terms.desc FROM terms WHERE terms.id='$rowid')||'$typedtext'||char(10) WHERE terms.id='$rowid'", _
"T07``T03`T03``UPDATE OR IGNORE terms SET desc=(SELECT DISTINCT trim(terms.desc,char(10)) FROM terms WHERE terms.id='$rowid') WHERE terms.id='$rowid'", _
"T08`Search terms: `T09`T09``c", _
"T09`SQLMenu`T03`T01`SELECT terms.id,(terms.id||' '||title) AS OUTPUT FROM terms WHERE terms.id LIKE '%$rowid%' OR title LIKE '%$rowid%' LIMIT 14`", _
"Q00`Enter Contact Name: `Q01`Q01``c", _
"Q01`SQLMenu`Q02`100`SELECT DISTINCT contacts.id, (contacts.name||' '||company.name||char(10)) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE company.name LIKE '%$rowid%' OR contacts.name LIKE '%$rowid%' ORDER BY contacts.id DESC LIMIT 14`", _
"Q02`Enter Description Title text: `Q03`Q03`SELECT quote.id,quote.id FROM quote ORDER BY quote.id DESC LIMIT 1`INSERT OR IGNORE INTO quote(contactid,quotedesc,date,expirydate,startdate,enddate,contracttype,billingaddressid,status,plustax,createdby,disabled) VALUES('$rowid','$typedtext',STRFTIME('%Y%m%d',datetime('now','localtime')),STRFTIME('%Y%m%d',datetime('now','localtime'),'+90 days'),STRFTIME('%Y%m%d',date('now','start of month','+1 month')),STRFTIME('%Y%m%d',date('now','start of month','+13 month','-1 day')),0,(SELECT contacts.addressid from contacts WHERE contacts.id='$rowid'),1,(SELECT company.plustax FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.id=$rowid),'$userid','0')", _
"Q03`Description: `Q64`S00`SELECT quote.quotedesc FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q64`Enter Description Title text: `Q03`Q03``UPDATE OR IGNORE quote SET quotedesc='$typedtext'", _
"Q03``Q03`S00`SELECT ('Quote: '||PRINTF('Q%07d',quote.id)||', ContactID:'||quote.contactid) as A FROM quote JOIN contacts ON contacts.id=quote.contactid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`SQLMenu`Q03`S00`SELECT '$rowid','Create Packing Slip' as A WHERE NOT EXISTS(SELECT '' FROM packingslip WHERE packingslip.qtid='$rowid')`INSERT or IGNORE INTO packingslip(qtid,date,createdby,notes) SELECT id AS qtid,STRFTIME('%Y%m%d%H%M',datetime('now','localtime')),'$userid',('Based on Quote: '||PRINTF('Q%07d',quote.id)) as A FROM quote WHERE quote.id='$rowid' LIMIT 1;UPDATE OR IGNORE quote SET status=3 WHERE quote.id='$rowid'", _
"Q03`SQLMenu`Q62`S00`SELECT packingslip.qtid,('PS: '||packingslip.qtid) AS A FROM packingslip WHERE packingslip.qtid='$rowid' LIMIT 1`", _
"Q03`SQLMenu`Q03`S00`SELECT '$rowid','Create Invoice' as A WHERE NOT EXISTS(SELECT '' FROM invoice WHERE invoice.qtid='$rowid')`INSERT or IGNORE INTO invoice(qtid,notes,date) SELECT quote.id,('Based on Quote: '||PRINTF('Q%07d',quote.id)),STRFTIME('%Y%m%d%H%M',datetime('now','localtime')) AS A FROM quote LEFT JOIN invoice ON invoice.qtid=quote.id WHERE quote.id='$rowid' LIMIT 1;UPDATE OR IGNORE quote SET status=3 WHERE quote.id='$rowid'", _
"Q03`SQLMenu`I03`S00`SELECT invoice.id,('Recent Invoice: '||PRINTF('I%07d',invoice.id)) AS A FROM invoice WHERE invoice.qtid='$rowid' ORDER by invoice.id DESC LIMIT 10`", _
"Q62``O03`O03`SELECT packingslip.id,packingslip.id FROM packingslip ORDER BY packingslip.id DESC LIMIT 1`", _
"Q03`Contact Company: `Q14`S00`SELECT (company.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Contact Name: `Q17`S00`SELECT (contacts.name) as A FROM quote JOIN contacts ON contacts.id=quote.contactid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Contact Email: `Q19`S00`SELECT (contacts.email) as A FROM quote JOIN contacts ON contacts.id=quote.contactid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Contact Phone: `Q21`S00`SELECT (contacts.cellphone) as A FROM quote JOIN contacts ON contacts.id=quote.contactid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Date: `Q23`S00`SELECT substr(quote.date,1,4)||'-'||substr(quote.date,5,2)||'-'||substr(quote.date,7,2) FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Contract Type: `Q24`S00`SELECT contracttype.title FROM quote LEFT JOIN contracttype ON contracttype.id=quote.contracttype WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Billing Address: `Q26`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Site Name: `Q28`S00`SELECT quote.sitename FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Site Address: `Q29`S00`SELECT (address.address||', '||address.city||', '||address.zip||', '||address.state||', '||address.country) as A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`SQLMenu`Q48`S00`SELECT $rowid,'Create Service Contract'`INSERT or IGNORE INTO qtscope(typeid,qtid) SELECT DISTINCT equipment.typeid,$rowid FROM equipment LEFT JOIN quote ON quote.contactid=equipment.contactid WHERE quote.id=$rowid AND equipment.typeid NOT IN(SELECT DISTINCT equipment.typeid FROM equipment LEFT JOIN quote ON quote.contactid=equipment.contactid LEFT JOIN qtscope on qtscope.qtid=quote.id WHERE quote.id=$rowid AND qtscope.typeid=equipment.typeid AND equipment.contactid=quote.contactid)", _
"Q03`SQLMenu`Q48`S00`SELECT qtscope.id,('Remove from Contract: '||type.name||' Qty:'||count(equipment.id)) AS A FROM qtscope LEFT JOIN quote ON quote.id=qtscope.qtid LEFT JOIN type ON type.id=qtscope.typeid LEFT JOIN equipment ON equipment.typeid=qtscope.typeid WHERE quote.contactid=equipment.contactid AND qtscope.qtid=$rowid  GROUP BY qtscope.id ORDER BY type.name ASC`DELETE FROM qtscope WHERE qtscope.id=$rowid", _
"Q03`Add Item Number from Sales Inventory`Q55`S00``", _
"Q03`Add from User Inventory`Q51`S00``", _
"Q03`SQLMenu`Q44`S00`SELECT qtinv.id,(inventory.name||', Qty:'||qtinv.qty||' - Item'||inventory.id) AS A FROM qtinv LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE qtinv.qtid='$rowid' ORDER BY qtinv.id DESC`", _
"Q44`Part: `Q44`Q03`SELECT (inventory.id||' - '||inventory.name) AS A FROM qtinv LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Qty: `Q58`Q03`SELECT (qtinv.qty) AS A FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Cost: `Q45`Q03`SELECT ('$'||printf('%.2f',qtinv.cost)) AS A FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Price: `Q46`Q03`SELECT ('$'||printf('%.2f',qtinv.price)) AS A FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Subtotal: `Q46b`Q03`SELECT ('$'||printf('%.2f',qtinv.subtotal)||' ('||printf('%.2f',qtinv.total)||' Total)') AS A FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Notes: `Q46c`Q03`SELECT (qtinv.notes) AS A FROM qtinv LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Add Taxes: `Q59`Q03`SELECT (CASE qtinv.plustax WHEN '1' THEN 'YES' ELSE 'NO' END) AS A FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Created by: `Q44`Q03`SELECT (user.name||', '||'U'||PRINTF('%01d',qtinv.createdby)) AS A FROM qtinv LEFT JOIN user ON user.id=qtinv.createdby WHERE qtinv.id='$rowid' LIMIT 1`", _
"Q44`Put into Own Inventory`Q47`Q03``", _
"Q45`Enter Part Cost`Q57`Q57``UPDATE OR IGNORE qtinv SET cost='$typedtext' WHERE qtinv.id='$rowid'", _
"Q46`Enter Part Price`Q57`Q57``UPDATE OR IGNORE qtinv SET price='$typedtext' WHERE qtinv.id='$rowid'", _
"Q46b`Override Part Total Price: `Q44`Q44``UPDATE OR IGNORE qtinv SET total='$typedtext',subtotal='$typedtext' WHERE qtinv.id='$rowid'", _
"Q46c`Enter Part Notes`Q44`Q44``UPDATE OR IGNORE qtinv SET notes='$typedtext' WHERE qtinv.id='$rowid'", _
"Q47``Q48`Q48``INSERT or IGNORE INTO userinv(inventoryid,userid,qty,date,notes,createdby,disabled) SELECT qtinv.inventoryid,'$userid','0',STRFTIME('%Y%m%d',datetime('now','localtime')),'','$userid','0' FROM qtinv WHERE qtinv.id='$rowid' AND NOT EXISTS(SELECT userinv.inventoryid FROM userinv LEFT JOIN qtinv ON qtinv.inventoryid=userinv.inventoryid WHERE qtinv.id='$rowid');UPDATE OR IGNORE qtinv SET qty=qty-1 WHERE qtinv.inventoryid=(SELECT qtinv.inventoryid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1) AND qtinv.id='$rowid' AND qtinv.qty<>0;UPDATE OR IGNORE userinv SET qty=qty+1,date=STRFTIME('%Y%m%d',datetime('now','localtime')) WHERE userinv.inventoryid=(SELECT qtinv.inventoryid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1);DELETE FROM qtinv WHERE qtinv.qty='0' AND qtinv.id='$rowid';", _
"Q48`1`Q03`Q03``", _
"Q51``Q52`Q52`SELECT '$rowid','$rowid'`", _
"Q52`SQLMenu`Q53`Q03`SELECT userinv.id,(userinv.inventoryid||' - '||inventory.name||', qty:'||userinv.qty) AS OUTPUT FROM userinv LEFT JOIN inventory ON inventory.id=userinv.inventoryid WHERE userinv.userid='$userid' LIMIT 99`", _
"Q53``Q54`Q54``UPDATE OR IGNORE quote SET supplierid=(SELECT inventory.supplierid FROM inventory LEFT JOIN userinv ON userinv.id='$rowid' WHERE inventory.id=userinv.inventoryid LIMIT 1) WHERE quote.id='$prowid';;;INSERT or IGNORE INTO qtinv(inventoryid,qtid,qty,notes,createdby,disabled) SELECT userinv.inventoryid,'$pprowid','0','','$userid','0' FROM userinv WHERE userinv.id='$rowid' AND NOT EXISTS(SELECT qtinv.inventoryid FROM qtinv LEFT JOIN userinv ON userinv.inventoryid=qtinv.inventoryid WHERE userinv.id='$rowid' AND qtinv.qtid='$prowid');UPDATE OR IGNORE userinv SET qty=qty-1 WHERE userinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND userinv.id='$rowid' AND userinv.qty<>0;UPDATE OR IGNORE qtinv SET qty=qty+1 WHERE qtinv.inventoryid=(SELECT userinv.inventoryid FROM userinv WHERE userinv.id='$rowid' LIMIT 1) AND qtinv.qtid='$pprowid';DELETE FROM userinv WHERE userinv.qty='0' AND userinv.id='$rowid';", _
"Q54`2`Q03`Q03``", _
"Q55`Enter Sales Item ID Number: `Q56`Q56``INSERT or IGNORE INTO qtinv(inventoryid,qtid,qty,cost,price,plustax,notes,createdby,disabled) SELECT inventory.id,'$rowid',0,cost,price,plustax,notes,'$userid','0' FROM inventory WHERE inventory.id='$typedtext' AND NOT EXISTS(SELECT qtinv.inventoryid FROM qtinv LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE inventory.id='$typedtext' AND qtinv.qtid='$rowid');UPDATE OR IGNORE inventory SET qty=qty-1 WHERE inventory.id=(SELECT inventory.id FROM inventory WHERE inventory.id='$typedtext' LIMIT 1) AND inventory.id='$typedtext' AND inventory.qty<>0;UPDATE OR IGNORE qtinv SET qty=qty+1 WHERE qtinv.inventoryid=(SELECT inventory.id FROM inventory WHERE inventory.id='$typedtext' LIMIT 1) AND qtinv.qtid='$rowid';;UPDATE OR IGNORE quote SET supplierid=(SELECT inventory.supplierid FROM inventory WHERE inventory.id='$typedtext' LIMIT 1) WHERE quote.id='$rowid'", _
"Q58`Enter Qty Amount: `Q57`Q57``UPDATE OR IGNORE qtinv SET qty='$typedtext' WHERE qtinv.id='$rowid'", _
"Q59``Q57`Q57``UPDATE OR IGNORE qtinv SET plustax=CASE plustax WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE qtinv.id='$rowid'", _
"Q03`Add Form`Q49`S00``", _
"Q49`SQLMenu`Q50`Q03`SELECT DISTINCT formfieldtitle.id,formfieldtitle.name FROM formfieldtitle WHERE formfieldtitle.disabled='0'`", _
"Q50``Q03`Q03`SELECT scformfields.qtid,scformfields.qtid FROM scformfields ORDER BY scformfields.id DESC LIMIT 1`INSERT OR IGNORE INTO scformfields(formfieldtitleid,qtid) VALUES('$rowid','$prowid');INSERT OR IGNORE INTO scf(scformfields,scfcolid,formfieldtitleid,value,qtid) SELECT (SELECT scformfields.id FROM scformfields ORDER BY scformfields.id DESC LIMIT 1),formfields.id AS scfcolid,formfields.fgrp AS formfieldtitleid,'' AS value,'$prowid' AS qtid FROM formfields WHERE formfields.fgrp='$rowid'", _
"Q03`Add Taxes: `Q43`S00`SELECT (CASE quote.plustax WHEN '1' THEN 'YES' ELSE 'NO' END)||' '||(SELECT ifnull(group_concat(A),('WARNING Salestax NOT defined for: '||state||', '||country)) AS A FROM (SELECT '('||taxname||' '||(taxrate*100)||'%)' AS A,address.state AS state,address.country AS country FROM quote LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state))) AS A FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q43``Q56`Q56``UPDATE OR IGNORE quote SET plustax=CASE plustax WHEN '1' THEN '0' WHEN '0' THEN '1' ELSE '0' END WHERE quote.id='$rowid'", _
"Q56``Q03`Q03``UPDATE OR IGNORE qtinv SET subtotal=qtinv.price*qtinv.qty WHERE qtinv.qtid='$rowid';UPDATE OR IGNORE qtinv SET total=qtinv.price*qtinv.qty WHERE qtinv.qtid='$rowid';UPDATE OR IGNORE qtinv SET total=(qtinv.price*qtinv.qty)+(qtinv.price*qtinv.qty)*(SELECT sum(salestaxes.taxrate) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN address ON address.id=(CASE quote.siteaddressid WHEN '' THEN quote.billingaddressid ELSE quote.siteaddressid END) LEFT JOIN salestaxes ON salestaxes.state=address.state AND salestaxes.country=address.country WHERE quote.id='$rowid' AND quote.plustax='1' group BY qtinv.id) WHERE qtinv.qtid='$rowid' AND qtinv.plustax='1';UPDATE OR IGNORE quote SET subtotal=(SELECT sum((qtinv.subtotal)) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid WHERE qtinv.qtid='$rowid'),total=(SELECT sum((qtinv.total)) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid WHERE qtinv.qtid='$rowid') WHERE quote.id='$rowid';;;UPDATE OR IGNORE qtinv SET costsubtotal=qtinv.cost*qtinv.qty WHERE qtinv.qtid='$rowid';UPDATE OR IGNORE qtinv SET costtotal=qtinv.cost*qtinv.qty WHERE qtinv.qtid='$rowid';UPDATE OR IGNORE qtinv SET costtotal=(qtinv.cost*qtinv.qty)+(qtinv.cost*qtinv.qty)*(SELECT sum(salestaxes.taxrate) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN company ON company.id=quote.supplierid LEFT JOIN address ON address.id=company.addressid LEFT JOIN salestaxes ON salestaxes.state=address.state AND salestaxes.country=address.country WHERE quote.id='$rowid' AND quote.plustax='1' group BY qtinv.id) WHERE qtinv.qtid='$rowid' AND qtinv.plustax='1';UPDATE OR IGNORE quote SET costsubtotal=(SELECT sum((qtinv.costsubtotal)) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid WHERE qtinv.qtid='$rowid'),costtotal=(SELECT sum((qtinv.costtotal)) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid WHERE qtinv.qtid='$rowid') WHERE quote.id='$rowid';", _
"Q57``Q44`Q44``UPDATE OR IGNORE qtinv SET subtotal=qtinv.qty*qtinv.price WHERE qtinv.id='$rowid'; UPDATE OR IGNORE qtinv SET total=(qtinv.qty*qtinv.price) WHERE qtinv.id='$rowid'; UPDATE OR IGNORE qtinv SET total=(qtinv.qty*qtinv.price)+qtinv.qty*qtinv.price*(SELECT sum(salestaxes.taxrate) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN address ON address.id=(CASE quote.siteaddressid WHEN '' THEN quote.billingaddressid ELSE quote.siteaddressid END) LEFT JOIN salestaxes ON salestaxes.state=address.state AND salestaxes.country=address.country WHERE qtinv.id='$rowid' AND quote.plustax='1' LIMIT 1) WHERE qtinv.id='$rowid' AND qtinv.plustax='1';UPDATE OR IGNORE quote SET subtotal=(SELECT sum(qtinv.subtotal) FROM qtinv WHERE qtinv.qtid=(SELECT qtinv.qtid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1)) WHERE quote.id='$prowid';UPDATE OR IGNORE quote SET total=(SELECT sum(qtinv.total) FROM qtinv WHERE qtinv.qtid=(SELECT qtinv.qtid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1)) WHERE quote.id='$prowid';;;UPDATE OR IGNORE qtinv SET costsubtotal=qtinv.qty*qtinv.cost WHERE qtinv.id='$rowid'; UPDATE OR IGNORE qtinv SET costtotal=(qtinv.qty*qtinv.cost) WHERE qtinv.id='$rowid'; UPDATE OR IGNORE qtinv SET costtotal=(qtinv.qty*qtinv.cost)+qtinv.qty*qtinv.cost*(SELECT sum(salestaxes.taxrate) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN company ON company.id=quote.supplierid LEFT JOIN address ON address.id=company.addressid LEFT JOIN salestaxes ON salestaxes.state=address.state AND salestaxes.country=address.country WHERE qtinv.id='$rowid' AND quote.plustax='1' LIMIT 1) WHERE qtinv.id='$rowid' AND qtinv.plustax='1';UPDATE OR IGNORE quote SET costsubtotal=(SELECT sum(qtinv.costsubtotal) FROM qtinv WHERE qtinv.qtid=(SELECT qtinv.qtid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1)) WHERE quote.id='$prowid';UPDATE OR IGNORE quote SET costtotal=(SELECT sum(qtinv.costtotal) FROM qtinv WHERE qtinv.qtid=(SELECT qtinv.qtid FROM qtinv WHERE qtinv.id='$rowid' LIMIT 1)) WHERE quote.id='$prowid';", _
"Q03`Currency: `Q31`S00`SELECT (CASE quote.currencyid WHEN '0' THEN 'USD' WHEN '1' THEN 'CDN' WHEN '2' THEN 'EUR' ELSE quote.currencyid END) AS A FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Subtotal: `Q33`S00`SELECT ((CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.subtotal)||' ('||(CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.total)||' Total)') AS A FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Cost Subtotal: `Q60`S00`SELECT ((CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.costsubtotal)||' ('||(CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '�' WHEN '4' THEN '�' ELSE '$' END)||printf('%.2f',quote.costtotal)||' Total)') AS A FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Hourly Rate: `Q34`S00`SELECT quote.hourlyrate FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Travel Rate: `Q35`S00`SELECT quote.travelrate FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Quote Valid Until Date: `Q36`S00`SELECT substr(quote.expirydate,1,4)||'-'||substr(quote.expirydate,5,2)||'-'||substr(quote.expirydate,7,2) FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Effective Contact Start Date: `Q37`S00`SELECT substr(quote.startdate,1,4)||'-'||substr(quote.startdate,5,2)||'-'||substr(quote.startdate,7,2) FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Effective Contact End Date: `Q38`S00`SELECT substr(quote.enddate,1,4)||'-'||substr(quote.enddate,5,2)||'-'||substr(quote.enddate,7,2) FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Preferred Maintenance Date: `Q39`S00`SELECT substr(quote.maintenancedate,1,4)||'-'||substr(quote.maintenancedate,5,2)||'-'||substr(quote.maintenancedate,7,2) FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Notes: `Q40`S00`SELECT quote.notes FROM quote WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Created by: `Q03`S00`SELECT (user.name||', '||'U'||PRINTF('%01d',quote.createdby)) AS A FROM quote LEFT JOIN user on user.id=quote.createdby WHERE quote.id='$rowid'`", _
"Q03`Status: `Q41`S00`SELECT status.status FROM quote LEFT JOIN status ON status.id=quote.status WHERE quote.id='$rowid'`", _
"Q03`Terms:`Q42`S00`SELECT ('ID:'||terms.id||char(13)||char(10)||'    '||replace(terms.desc,char(10),char(13)||char(10)||'    '))AS A FROM quote LEFT JOIN terms ON quote.termsid=terms.id WHERE quote.id='$rowid' LIMIT 1`", _
"Q03`Email Quote `Q61`S00``", _
"Q03`Generate PDF `Q61`S00``", _
"Q03`Email to Self `Q61`S00``", _
"Q03`Email to Quote Creator `Q61`S00``", _
"Q14`Search Company Name: `Q15`Q15``c", _
"Q15`SQLMenu`Q16`Q03`SELECT contacts.id,(company.name ||' '||company.email ||' '||company.officephone||' '||company.cellphone) AS OUTPUT FROM company LEFT JOIN contacts ON contacts.companyid=company.id WHERE company.name LIKE '%$rowid%' OR company.email LIKE '%$rowid%' OR company.officephone LIKE '%$rowid%' OR company.cellphone LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET contactid='$rowid' WHERE quote.id='$pprowid'", _
"Q16`2`Q03`Q03``", _
"Q17`Search Contact Name: `Q18`Q18``c", _
"Q18`SQLMenu`Q16`Q03`SELECT contacts.id,(contacts.name ||' '||contacts.email ||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.name LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET contactid='$rowid' WHERE quote.id='$pprowid'", _
"Q19`Search Contact Email: `Q20`Q20``c", _
"Q20`SQLMenu`Q16`Q03`SELECT contacts.id,(contacts.name ||' '||contacts.email ||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.email LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET contactid='$rowid' WHERE quote.id='$pprowid'", _
"Q21`Search Contact Phone: `Q22`Q22``c", _
"Q22`SQLMenu`Q16`Q03`SELECT contacts.id,(contacts.name ||' '||contacts.email ||' '||contacts.officephone||' '||contacts.cellphone) AS OUTPUT FROM contacts LEFT JOIN company ON company.id=contacts.companyid WHERE contacts.officephone LIKE '%$rowid%' OR contacts.cellphone LIKE '%$rowid%' OR contacts.fax LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET contactid='$rowid' WHERE quote.id='$pprowid'", _
"Q23`Enter Quote Date: `Q03`Q03``UPDATE OR IGNORE quote SET date=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE quote.id='$rowid'", _
"Q24`SQLMenu`Q25`Q48`SELECT contracttype.id,(contracttype.title||' = $'||contracttype.rate) AS OUTPUT FROM contracttype`UPDATE OR IGNORE quote SET contracttype='$rowid' WHERE quote.id='$prowid'", _
"Q25`1`Q03`Q03``", _
"Q26`Search Address: `Q27`Q27``c", _
"Q27`SQLMenu`Q16`Q03`SELECT address.id,(address.address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET billingaddressid='$rowid' WHERE quote.id='$pprowid'", _
"Q28`Enter Site Name: `Q03`Q03``UPDATE OR IGNORE quote SET sitename='$typedtext' WHERE quote.id='$rowid'", _
"Q29`Search Address: `Q30`Q30``c", _
"Q30`SQLMenu`Q16`Q03`SELECT '','Set to blank' UNION ALL SELECT address.id,(address.address ||' '||city ||' '||state ||' '||zip) AS OUTPUT FROM address WHERE address LIKE '%$rowid%' OR city LIKE '%$rowid%' OR state LIKE '%$rowid%' OR zip LIKE '%$rowid%' LIMIT 14`UPDATE OR IGNORE quote SET siteaddressid='$rowid' WHERE quote.id='$pprowid'", _
"Q31`SQLMenu`Q32`Q03`SELECT 0,'USD' AS A UNION ALL SELECT 1,'CDN' UNION ALL SELECT 2,'EURO' UNION ALL SELECT 3,'GBP'`UPDATE OR IGNORE quote SET currencyid='$rowid' WHERE quote.id='$prowid'", _
"Q32`1`Q03`Q03``", _
"Q33`Override SubTotal: `Q03`Q03``UPDATE OR IGNORE quote SET total='$typedtext',subtotal='$typedtext' WHERE quote.id='$rowid'", _
"Q60`Override SubTotal: `Q03`Q03``UPDATE OR IGNORE quote SET costtotal='$typedtext',costsubtotal='$typedtext' WHERE quote.id='$rowid'", _
"Q34`Enter Hourly Rate: `Q03`Q03``UPDATE OR IGNORE quote SET hourlyrate='$typedtext' WHERE quote.id='$rowid'", _
"Q35`Enter Travel Rate: `Q03`Q03``UPDATE OR IGNORE quote SET travelrate='$typedtext' WHERE quote.id='$rowid'", _
"Q36`Quote Expiry Date: `Q03`Q03``UPDATE OR IGNORE quote SET expirydate=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE quote.id='$rowid'", _
"Q37`Contract Start Date: `Q03`Q03``UPDATE OR IGNORE quote SET startdate=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE quote.id='$rowid'", _
"Q38`Contract End Date: `Q03`Q03``UPDATE OR IGNORE quote SET enddate=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE quote.id='$rowid'", _
"Q39`Preferred Maintenance Date: `Q03`Q03``UPDATE OR IGNORE quote SET maintenancedate=replace(replace(replace(replace(('$typedtext'),'-',''),' ',''),'.',''),':','') WHERE quote.id='$rowid'", _
"Q40`Enter Notes: `Q03`Q03``UPDATE OR IGNORE quote SET notes='$typedtext' WHERE quote.id='$rowid'", _
"Q41`Status: `Q03`Q03``UPDATE OR IGNORE quote SET status='$typedtext' WHERE quote.id='$rowid'", _
"Q42`Enter Service Agreement Term ID Number: `Q03`Q03``UPDATE OR IGNORE quote SET termsid='$typedtext' WHERE quote.id='$rowid'", _
"Q61`qreport`Q03```c", _
"457``458`401`SELECT 1,(CASE count(1) WHEN 1 THEN substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2) ELSE '0' END) AS A FROM servicecall WHERE servicecall.dispatchid='$rowid' AND substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2)='$prowid' GROUP BY (servicecall.status) HAVING servicecall.status`", _
"458``459`401``UPDATE OR IGNORE dispatch SET status= (SELECT CASE count(DISTINCT servicecall.status) WHEN 1 THEN '3' ELSE '2' END  FROM servicecall JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.dispatchid='$prowid') WHERE dispatch.id='$prowid'", _
"459`3`460`401``", _
"460`2`454`401``", _
"X01`Add Salestax`X10`100``", _
"X01`Find Salestax`X08`100``", _
"X01`SQLMenu`X03`X01`SELECT salestaxes.id,('Country: '||country||', State:'||state||', Taxname:'||taxname||', taxrate:'||taxrate) AS OUTPUT FROM salestaxes ORDER BY salestaxes.id DESC LIMIT 14`", _
"X03`Country: `X04`X01`SELECT DISTINCT country FROM salestaxes WHERE salestaxes.id='$rowid'`", _
"X03`State: `X05`X01`SELECT DISTINCT state FROM salestaxes WHERE salestaxes.id='$rowid'`", _
"X03`Tax Name: `X06`X01`SELECT DISTINCT taxname FROM salestaxes WHERE salestaxes.id='$rowid'`", _
"X03`Tax Rate: `X07`X01`SELECT DISTINCT taxrate FROM salestaxes WHERE salestaxes.id='$rowid'`", _
"X04`Enter Country Code: `X03`X03``UPDATE OR IGNORE salestaxes SET country=upper('$typedtext') WHERE salestaxes.id='$rowid'", _
"X05`Enter State Code: `X03`X03``UPDATE OR IGNORE salestaxes SET state=(CASE WHEN upper('$typedtext')='N/A' THEN '' WHEN length('$typedtext')>1 THEN upper('$typedtext') ELSE '' END) WHERE salestaxes.id='$rowid'", _
"X06`Enter Tax Name: `X03`X03``UPDATE OR IGNORE salestaxes SET taxname='$typedtext' WHERE salestaxes.id='$rowid'", _
"X07`Enter Tax Rate: `X03`X03``UPDATE OR IGNORE salestaxes SET taxrate=replace(upper('$typedtext'),' ','') WHERE salestaxes.id='$rowid'", _
"X08`Enter Tax search term: `X09`X09``c", _
"X09`SQLMenu`X03`X01`SELECT salestaxes.id,(country||' '||state||' '||taxname||' '||taxrate) AS OUTPUT FROM salestaxes WHERE taxname LIKE '%$rowid%' OR country LIKE '%$rowid%' OR state LIKE '%$rowid%' OR taxrate LIKE '%$rowid%' LIMIT 14`", _
"X10`Enter Country Code: `X11`X11`SELECT '$typedtext','$typedtext'`", _
"X11`Enter State Code: `X03`X03`SELECT '$typedtext','$typedtext'`INSERT OR IGNORE INTO salestaxes(country,state) VALUES('$rowid','$typedtext')", _
"W00`2`W01`W00``", _
"W01`Add Work Type`W06`100``", _
"W01`Find Work Type`W04`100``", _
"W02`Work Type: `W03`W00`SELECT DISTINCT worktype FROM worktype WHERE worktype.id='$rowid'`", _
"W01`SQLMenu`W03`W00`SELECT worktype.id,worktype.worktype AS OUTPUT FROM worktype ORDER BY worktype.id ASC LIMIT 99`", _
"W03`Enter Worktype: `W00`W00``UPDATE OR IGNORE worktype SET worktype=('$typedtext') WHERE worktype.id='$rowid'", _
"W04`Enter search term: `W05`W05``c", _
"W05`SQLMenu`W02`W00`SELECT worktype.id,worktype.worktype AS OUTPUT FROM worktype WHERE worktype.worktype LIKE '%$rowid%' OR worktype.id LIKE '%$rowid%' LIMIT 14`", _
"W06`Enter Work type text: `W00`W00`SELECT '$typedtext','$typedtext'`INSERT OR IGNORE INTO worktype(worktype) VALUES('$typedtext')", _
"100`Find Address`715`101``" _
]