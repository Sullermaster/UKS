
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры


&НаСервере
Функция ПоулчитьСписокВидаОборудования()

	Список = Новый СписокЗначений;
	
	Спр = Справочники.ВидыОборудования.НайтиПоНаименованию("Компьютер");
	Список.Добавить(Спр.Ссылка);
	Спр = Справочники.ВидыОборудования.НайтиПоНаименованию("Ноутбук");
	Список.Добавить(Спр.Ссылка);
	
	Возврат Список;
	
КонецФункции

&НаСервере
Процедура ДобавитьНовуюСтрокуВДЗ(НоваяСтрокаСписок,ПараметрыСтроки) Экспорт
		
	НоваяСтрокаСписок.Наименование = ПараметрыСтроки.Наименование;
	НоваяСтрокаСписок.Признак = ПараметрыСтроки.Признак;
	НоваяСтрокаСписок.Подразделение = ПараметрыСтроки.Подразделение;
	НоваяСтрокаСписок.Размещение = ПараметрыСтроки.Размещение;
	НоваяСтрокаСписок.ЭтоГруппа = ПараметрыСтроки.ЭтоГруппа;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоУмолчанию()
	
	ДеревоЗначенийКомпьютеров = РеквизитФормыВЗначение("ДеревоКомпьютеров");
	
	ПараметрыСтроки = Новый Структура("Наименование,Признак");
		
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	              |	Оборудование.Наименование КАК Наименование,
	              |	Оборудование.Размещение КАК Размещение,
	              |	Оборудование.ОтветственноеЛицо.Подразделение КАК Подразделение,
	              |	Оборудование.ПометкаУдаления КАК Признак,
	              |	Оборудование.Родитель КАК Родитель
	              |ИЗ
	              |	Справочник.Оборудование КАК Оборудование
	              |ГДЕ
	              |	Оборудование.ВидОборудования В(&СписокВидаОборудования)
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	Родитель,
	              |	Размещение
	              |ИТОГИ ПО
	              |	Родитель,
	              |	Размещение"; 
				  
	СписокВидаОборудованя = ПоулчитьСписокВидаОборудования();			  
	Запрос.УстановитьПараметр("СписокВидаОборудования",СписокВидаОборудованя);
	РезултатЗапроса = Запрос.Выполнить();
	
	ТекущийРодитель = "";
	//ДеревоЗначенийКомпьютеров = РезултатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаЭтажи = РезултатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока ВыборкаЭтажи.Следующий() Цикл
		
		НоваяСтрокаСписок = ДеревоЗначенийКомпьютеров.Строки.Добавить();
		ПараметрыСтроки.Вставить("Признак",Ложь);
		ПараметрыСтроки.Вставить("Наименование",ВыборкаЭтажи.Родитель);
		ПараметрыСтроки.Вставить("Подразделение",ВыборкаЭтажи.Подразделение);
		ПараметрыСтроки.Вставить("Размещение",ВыборкаЭтажи.Родитель);
		ПараметрыСтроки.Вставить("ЭтоГруппа",Истина);
		ДобавитьНовуюСтрокуВДЗ(НоваяСтрокаСписок,ПараметрыСтроки);
		
		ВыборкаКабинеты = ВыборкаЭтажи.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаКабинеты.Следующий() Цикл
			СтрокаДереваДоп = НоваяСтрокаСписок.Строки.Добавить();
			ПараметрыСтроки.Вставить("Признак",Ложь);
			ПараметрыСтроки.Вставить("Наименование",ВыборкаКабинеты.Размещение);
			ПараметрыСтроки.Вставить("Подразделение",ВыборкаКабинеты.Подразделение);
			ПараметрыСтроки.Вставить("Размещение",ВыборкаКабинеты.Размещение);
			ПараметрыСтроки.Вставить("ЭтоГруппа",Истина);
			ДобавитьНовуюСтрокуВДЗ(СтрокаДереваДоп,ПараметрыСтроки);
			
			ВыборкаПК = ВыборкаКабинеты.Выбрать();
			Пока ВыборкаПК.Следующий() Цикл
				СтрокаДереваПК = СтрокаДереваДоп.Строки.Добавить();
				ПараметрыСтроки.Вставить("Наименование",ВыборкаПК.Наименование);
				ПараметрыСтроки.Вставить("Признак",Ложь);
				ПараметрыСтроки.Вставить("Подразделение",ВыборкаПК.Подразделение);
				ПараметрыСтроки.Вставить("Размещение",ВыборкаПК.Размещение);
				ПараметрыСтроки.Вставить("ЭтоГруппа",Ложь);
				ДобавитьНовуюСтрокуВДЗ(СтрокаДереваПК,ПараметрыСтроки);
				
			КонецЦикла;	
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначенийКомпьютеров, "ДеревоКомпьютеров");
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКомпьютеровПризнакПриИзменении(Элемент)
	
	Если Элементы.ДеревоКомпьютеров.ТекущаяСтрока<>Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоКомпьютеров.ТекущиеДанные;	
		ЭлементыТабличнойЧасти = ТекущиеДанные.ПолучитьЭлементы();
		Для Каждого ЭлементТаблицы Из ЭлементыТабличнойЧасти Цикл
			ЭлементТаблицы.Признак = ТекущиеДанные.Признак;
			ЭлементыТабличнойЧасти2 = ЭлементТаблицы.ПолучитьЭлементы();
			Для Каждого ЭлементТаблицы2 Из ЭлементыТабличнойЧасти2 Цикл
				ЭлементТаблицы2.Признак = ТекущиеДанные.Признак;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуСпискаПК()
	
	ДеревоЗначенийКомпьютеров = РеквизитФормыВЗначение("ДеревоКомпьютеров");
	
	СтрокаПК = "";
	Для Каждого СтрокаДерева Из ДеревоЗначенийКомпьютеров.Строки Цикл
		Если СтрокаДерева.ЭтоГруппа Тогда
			Для Каждого ПодСтрокаДерева Из СтрокаДерева.Строки Цикл
				Если ПодСтрокаДерева.ЭтоГруппа Тогда
					Для Каждого ПодСтрокаДерева2 Из ПодСтрокаДерева.Строки Цикл
						Если ПодСтрокаДерева2.Признак Тогда
							СтрокаПК = СтрокаПК+""+ПодСтрокаДерева2.Наименование+",";
						КонецЕсли;
					КонецЦикла;
				Иначе	
					Если ПодСтрокаДерева.Признак Тогда
						СтрокаПК = СтрокаПК+""+ПодСтрокаДерева.Наименование+",";
					КонецЕсли;
				КонецЕсли;		
			КонецЦикла;
		Иначе
			Если СтрокаДерева.Признак Тогда
				СтрокаПК = СтрокаПК+""+СтрокаДерева.Наименование+",";
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;
	
	СтрокаПК = Лев(СтрокаПК,СтрДлина(СтрокаПК)-1);
	Возврат СтрокаПК;
	
КонецФункции

&НаКлиенте
Процедура ОтправитьСообщениеPowerShell(Команда)
	
	СписокПК = ПолучитьСтрокуСпискаПК();
	Если Не ЗначениеЗаполнено(Объект.ТекстСообщения) Тогда
		ПоказатьПредупреждение(,"Сообщение НЕ НАПИСАНО!");
		Возврат;
	КонецЕсли;
	
	СобщениеПолюзователям = СокрЛП(Объект.ТекстСообщения);
	//ЗапуститьПриложение("powershell -WindowStyle Hidden -executionpolicy unrestricted -command Invoke-Command -ComputerName "+СокрЛП(СписокПК)+" -ScriptBlock {msg * "+СокрЛП(СобщениеПолюзователям)+"}","runas /user:iris@ipgvh.local /savecred C:\Windows\System32\WindowsPowerShell\v1.0\",Ложь);
	
	ЗапуститьПриложение("runas /user:iris@ipgvh.local /savecred C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -executionpolicy unrestricted -command Invoke-Command -ComputerName "+СокрЛП(СписокПК)+" -ScriptBlock {msg * "+СокрЛП(СобщениеПолюзователям)+"}",,Ложь);
	
	ПоказатьПредупреждение(,"Сообщение отправлено!");
	
КонецПроцедуры
