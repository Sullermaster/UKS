
&НаКлиенте
Процедура ПечатьЗаказа(Команда)
	ТаблДок = ПечатьЗаказаНаСервере();
	                   
	ТаблДок.ОтображатьСетку = Ложь;
	ТаблДок.Защита = Истина;
	ТаблДок.ТолькоПросмотр = Истина;
	ТаблДок.ОтображатьЗаголовки = Ложь;

	ТаблДок.Показать();

КонецПроцедуры

&НаСервере
Функция ПечатьЗаказаНаСервере()
	ТаблДок = Новый ТабличныйДокумент;
   Макет = Документы.ЗаказЗаявкаРаспечатка.ПолучитьМакет("МакетдляЗаказЗаявок");
   
   Обл = Макет.ПолучитьОбласть("Заказчик");
   
   Обл.Параметры.Подразд = Объект.Отдел;
   Обл.Параметры.тел = Объект.телефон;
   Обл.Параметры.ком = Объект.Комната;
   Обл.Параметры.ФИО = Объект.ФИОЗаказчика;
   Обл.Параметры.НазОбъ = Объект.НазваниеОбъекта;
   Обл.Параметры.Видраб = Объект.ВидРабот;
   ТаблДок.Вывести(Обл);  
   
   Шапка = Макет.ПолучитьОбласть("ШапкаТаблицы");
ТаблДок.Вывести(Шапка); 
   
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.НомерСтроки КАК НомерСтроки,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.ФайлДляРаспечатки КАК ФайлДляРаспечатки,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.Формат КАК Формат,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.КоличествоОригинала КАК КоличествоОригинала,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.Тираж КАК Тираж,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.ОсобыеОтметкиИсполнителя КАК ОсобыеОтметкиИсполнителя,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.КоличествоЦветных КАК КоличествоЦветных,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.КоличествоЧерноБелых КАК КоличествоЧерноБелых,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.НаименованиеЧертежныхРабот КАК НаименованиеЧертежныхРабот,
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.Двухсторонний КАК Двухсторонний
		|ИЗ
		|	Документ.ЗаказЗаявкаРаспечатка.ТабличнаяЧертежныхРабот КАК ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот
		|ГДЕ
		|	ЗаказЗаявкаРаспечаткаТабличнаяЧертежныхРабот.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Стр = Макет.ПолучитьОбласть("Таблица");
    ТекстВОтметкиИсп = "";
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
	    Стр.Параметры.наименчертраб  = ВыборкаДетальныеЗаписи.НаименованиеЧертежныхРабот;
	    Стр.Параметры.формат = ВыборкаДетальныеЗаписи.Формат;
	    Стр.Параметры.колориг = ВыборкаДетальныеЗаписи.КоличествоОригинала;
	    Стр.Параметры.тираж = ВыборкаДетальныеЗаписи.Тираж;
		Если ВыборкаДетальныеЗаписи.Двухсторонний Тогда
			ТекстВОтметкиИсп = "Двусторонняя печать" + ВыборкаДетальныеЗаписи.ОсобыеОтметкиИсполнителя;
		Иначе
			ТекстВОтметкиИсп = ВыборкаДетальныеЗаписи.ОсобыеОтметкиИсполнителя;
		КонецЕсли;
	    Стр.Параметры.отметки = ТекстВОтметкиИсп;
	    Стр.Параметры.Цвет = ВыборкаДетальныеЗаписи.КоличествоЦветных;
	    Стр.Параметры.Черн = ВыборкаДетальныеЗаписи.КоличествоЧерноБелых; 	
		ТаблДок.Вывести(Стр);
		
	КонецЦикла;

   Сотр = Макет.ПолучитьОбласть("Исполнитель");
   Сотр.Параметры.датасдач = Формат(Объект.ДатаСдачиВРаботу,"ДЛФ=DD");
   Сотр.Параметры.датавып = Формат(Объект.ДатаВыполненияЗаказа,"ДЛФ=DD");
   Сотр.Параметры.ФИОприн = Объект.Принял;
   ТаблДок.Вывести(Сотр);

   Возврат ТаблДок;
КонецФункции

&НаСервере
Процедура ФИОЗаказчикаПриИзмененииНаСервере()
	
	Объект.Отдел = Объект.ФИОЗаказчика.Подразделение;
	ОтделПриИзмененииНаСервере();
	Элементы.Телефон.СписокВыбора.ЗагрузитьЗначения(Объект.Отдел.Кабинеты.ВыгрузитьКолонку("ВнутреннийНомер")); 
	Элементы.Комната.СписокВыбора.ЗагрузитьЗначения(Объект.Отдел.Кабинеты.ВыгрузитьКолонку("НомерКабинета"));

КонецПроцедуры

&НаКлиенте
Процедура ФИОЗаказчикаПриИзменении(Элемент)
	ФИОЗаказчикаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтделПриИзмененииНаСервере()
	Элементы.Телефон.СписокВыбора.Очистить();
	Элементы.Комната.СписокВыбора.Очистить();
	Если Объект.Отдел = Справочники.Подразделения.ПустаяСсылка() Тогда
		НовыйМассив1 = Новый Массив();
		НовыйФиксМасс1 = Новый ФиксированныйМассив(НовыйМассив1);
		Элементы.ФИОЗаказчика.СвязиПараметровВыбора = НовыйФиксМасс1;
	Иначе
		НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Подразделение", "Объект.Отдел");
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НоваяСвязь);
		НовыйФиксМасс = Новый ФиксированныйМассив(НовыйМассив);
		
		Элементы.ФИОЗаказчика.СвязиПараметровВыбора = НовыйФиксМасс;
		
		Элементы.Телефон.СписокВыбора.ЗагрузитьЗначения(Объект.Отдел.Кабинеты.ВыгрузитьКолонку("ВнутреннийНомер")); 
		Элементы.Комната.СписокВыбора.ЗагрузитьЗначения(Объект.Отдел.Кабинеты.ВыгрузитьКолонку("НомерКабинета"));
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ОтделПриИзменении(Элемент)
	ОтделПриИзмененииНаСервере();
	Объект.телефон = "";
	Объект.Комната = "";
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПринимающихРаботу()
	
	Элементы.Принял.СписокВыбора.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка,
		|	Сотрудники.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.ПометкаУдаления = ЛОЖЬ
		|	И Сотрудники.Уволен = ЛОЖЬ
		|	И Сотрудники.ВыпускПроектов = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Элементы.Принял.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка,ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Проведен Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	Если Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.ПустаяСсылка() Тогда
		Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.Новый;
	КонецЕсли;
	
	//Если Объект.ДатаСдачиВРаботу = Дата(1,1,1) Тогда 
	//	Объект.ДатаСдачиВРаботу = ТекущаяДата();
	//КонецЕсли;
	
	Если РольДоступна("ВыдачаПроектов") Тогда
		Элементы.НомерЯчейки.ТолькоПросмотр = Истина;
	ИначеЕсли РольДоступна("Администратор") Тогда
		
	Иначе
		Элементы.Принял.ТолькоПросмотр = Истина;
		Элементы.ДатаВыполненияЗаказа.ТолькоПросмотр = Истина;
		Элементы.Комментарий.ТолькоПросмотр = Истина;
		Элементы.СостояниеЗаказа.ТолькоПросмотр = Истина; 
		Элементы.НомерЯчейки.ТолькоПросмотр = Истина;
		Элементы.Отдел.ТолькоПросмотр = Истина;
		Если Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.Готов Тогда 
			Элементы.ЗакрытьЯчейку.ТолькоПросмотр = Ложь;
		Иначе
			Элементы.ЗакрытьЯчейку.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Объект.Отдел = ПараметрыСеанса.ТекущийПользователь.Подразделение;
		КоманднаяПанель.ПодчиненныеЭлементы.ФормаЗаписатьИЗакрыть.Видимость = Истина;
	КонецЕсли;
	
	ОтделПриИзмененииНаСервере();
	ВидРаботПриИзмененииНаСервере();
	
	ЗаполнитьСписокПринимающихРаботу();
	
	Элементы.ФормаЗакрытьЯчейку.Пометка = Объект.ЗакрытьЯчейку;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтрытьФайл(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", ЭтотОбъект);
    НачатьЗапускПриложения(Оповещение, Объект.ПутьКФайлу,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗапускПриложения(КодВозврата, ДополнительныйПараметр) Экспорт

КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//ДополнительныеПараметры = Новый Структура;
	//ДополнительныеПараметры.Вставить("ВыборЗавершение", Новый ОписаниеОповещения("ВложениеВыборЗавершение", ЭтотОбъект));
	//Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	//НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
    Если Не Подключено Тогда
        Оповещение = Новый ОписаниеОповещения ("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
        ТекстСообщения = НСтр("ru='Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
        ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
    Иначе
        ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        НачатьУстановкуРасширенияРаботыСФайлами(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВложениеВыборЗавершение(ДополнительныеПараметры, ДопПараметр) Экспорт
    НачатьПолучениеКаталогаДокументов(Новый ОписаниеОповещения("КаталогДокументовЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КаталогДокументовЗавершение(ИмяКаталогаДокументов, ДополнительныеПараметры) Экспорт 
	Если Объект.ВидРабот = ПредопределенноеЗначение("Перечисление.ВидРабодДляПечатиПроектов.СканированиеВФайл") Тогда 
	ДиалогФыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога); 
	ДиалогФыбораФайла.Заголовок = "Выберите путь к файлу";
    Иначе		
	ДиалогФыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
	ДиалогФыбораФайла.Заголовок = "Выберите файл";
	КонецЕсли;
	ДиалогФыбораФайла.ПредварительныйПросмотр = Истина;
	ДиалогФыбораФайла.ИндексФильтра = 0;	
	ОписаниеОп = новый ОписаниеОповещения("КаталогВыбран", ЭтотОбъект);
	ДиалогФыбораФайла.Показать(ОписаниеОп);
КонецПроцедуры 

&НаКлиенте
Процедура КаталогВыбран(ВыбранныеФайлы, ДополнительныеПараметры)  Экспорт
	Если ВыбранныеФайлы<>Неопределено и ВыбранныеФайлы.Количество()>0 Тогда
		ТекущаяЯчейка = Элементы.ТабличнаяЧертежныхРабот.ТекущиеДанные;
		ТекущаяЯчейка.ФайлДляРаспечатки = ВыбранныеФайлы[0];
		Если Объект.ВидРабот = ПредопределенноеЗначение("Перечисление.ВидРабодДляПечатиПроектов.СканированиеВФайл") Тогда 
			
		Иначе
			Если ТекущаяЯчейка.НаименованиеЧертежныхРабот = "" Тогда 
				ТекущаяЯчейка.НаименованиеЧертежныхРабот = ВыборТекста(ВыбранныеФайлы[0]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;      
КонецПроцедуры


&НаКлиенте
Процедура ТабличнаяЧертежныхРаботФайлДляРаспечаткиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("ВыборЗавершение", Новый ОписаниеОповещения("ВложениеВыборЗавершение", ЭтотОбъект));
    Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры


&НаКлиенте
Процедура ТабличнаяЧертежныхРаботФайлДляРаспечаткиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", ЭтотОбъект);
	ТекущаяЯчейка = Элементы.ТабличнаяЧертежныхРабот.ТекущиеДанные;
	НачатьЗапускПриложения(Оповещение, ТекущаяЯчейка.ФайлДляРаспечатки,, Истина);
КонецПроцедуры


&НаКлиенте
Процедура ПослеПредупреждения(Параметры) Экспорт
КонецПроцедуры

&НаСервере
Процедура ВидРаботПриИзмененииНаСервере()
	Если Объект.ВидРабот = Перечисления.ВидРабодДляПечатиПроектов.Фальцовка Или
		Объект.ВидРабот = Перечисления.ВидРабодДляПечатиПроектов.Переплет Тогда
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Видимость = Ложь;
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботТираж.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЦветных.Видимость = Ложь;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЧерноБелых.Видимость = Ложь;
        Элементы.ТабличнаяЧертежныхРаботДвухсторонний.Видимость = Ложь;
		
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Заголовок = "Кол-во штук оригинала";
	ИначеЕсли Объект.ВидРабот = Перечисления.ВидРабодДляПечатиПроектов.Ксерокопирование Тогда
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Видимость = Ложь;
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботТираж.Видимость = Ложь;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЦветных.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЧерноБелых.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботДвухсторонний.Видимость = Истина;
		
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Заголовок = "Кол-во листов оригинала";
		
	ИначеЕсли Объект.ВидРабот = Перечисления.ВидРабодДляПечатиПроектов.СканированиеВФайл Тогда
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботТираж.Видимость = Ложь;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЦветных.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЧерноБелых.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботДвухсторонний.Видимость = Ложь;
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Заголовок = "Место сохранения отсканированного документа";
		
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Заголовок = "Кол-во листов оригинала";
		
	ИначеЕсли Объект.ВидРабот = Перечисления.ВидРабодДляПечатиПроектов.ПечатьИзФайла Тогда
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Видимость = Ложь;
		Элементы.ТабличнаяЧертежныхРаботТираж.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЦветных.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЧерноБелых.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботДвухсторонний.Видимость = Истина;
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Заголовок = "Расположение файла";
		
	Иначе
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботТираж.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЦветных.Видимость = Истина;
        Элементы.ТабличнаяЧертежныхРаботКоличествоЧерноБелых.Видимость = Истина;
		Элементы.ТабличнаяЧертежныхРаботДвухсторонний.Видимость = Истина;
		
		Элементы.ТабличнаяЧертежныхРаботФайлДляРаспечатки.Заголовок = "Расположение файла";
		
		Элементы.ТабличнаяЧертежныхРаботКоличествоОригинала.Заголовок = "Кол-во листов оригинала";
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВидРаботПриИзменении(Элемент)
	ВидРаботПриИзмененииНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура АсинхронноеПодключение()
   ПодключитьРасширение(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьРасширение(Установить) Экспорт
   НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ПослеПодключения", ЭтотОбъект, Установить));
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключения(Подключено,Установить) Экспорт

   Если Подключено Тогда
	   //Состояние("Ждите…. Идет чтение файла.");
   ИначеЕсли Установить Тогда
       НачатьУстановкуРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ПодключитьРасширение", ЭтотОбъект, Ложь));
   Иначе
       ВызватьИсключение "Ваш браузер не поддерживает работу с файлами. Не удалось подключить расширение работы с файлами!";
   КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	АсинхронноеПодключение();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Для Каждого Ключ Из ПараметрыЗаписи Цикл
		ЗначениеПараметраЗаписи = Ключ.Значение;
	КонецЦикла;
	
	Если ЗначениеПараметраЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыполненияЗаказаПриИзменении(Элемент)
	Если Объект.Принял = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка") Тогда 
		Объект.ДатаВыполненияЗаказа = Дата(1,1,1);
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Не выбран принимающий заказ.", , "Внимание!" );
	ИначеЕсли Не Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда	
		Объект.ДатаВыполненияЗаказа = Дата(1,1,1);
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Дату выполнения можно указать только у готового заказа.", , "Внимание!" ); 	
	ИначеЕсли НачалоДня(Объект.ДатаСдачиВРаботу) > НачалоДня(Объект.ДатаВыполненияЗаказа) И Не Объект.ДатаСдачиВРаботу = Дата(1,1,1) Тогда 
		Объект.ДатаВыполненияЗаказа = Дата(1,1,1);
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Дата выполнения не может быть раньше чем дата сдачи в работу.", , "Внимание!" ); 	
	КонецЕсли;
КонецПроцедуры
	
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	Для Каждого Ключ Из ПараметрыЗаписи Цикл
		ЗначениеПараметраЗаписи = Ключ.Значение;
	КонецЦикла;

	Если ЗначениеПараметраЗаписи = РежимЗаписиДокумента.Проведение И Не Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда 
		
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Нельзя закрыть неготовый заказ", , "Внимание!" );    

	ИначеЕсли ЗначениеПараметраЗаписи = РежимЗаписиДокумента.Проведение 
		И Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.ФИОЗаказчика)Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Введите заказчика.", , "Внимание!" );
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Отдел) Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Введите отдел заказчика.", , "Внимание!" ); 
		Отказ = Истина;		
	ИначеЕсли Не ЗначениеЗаполнено(Объект.ВидРабот) Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Введите вид работ.", , "Внимание!" ); 	
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.НазваниеОбъекта) Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Введите название объекта.", , "Внимание!" ); 	
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.ДатаСдачиВРаботу) Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Введите дату сдачи в работу.", , "Внимание!" ); 	
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.ТабличнаяЧертежныхРабот) Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Добавьте наименование чертежных работ.", , "Внимание!" ); 	
		Отказ = Истина;
	КонецЕсли;
	Если  Отказ = Ложь Тогда
		ПроверкаПередЗаписю();
		Если Объект.НомерЯчейки = 0 Тогда
			Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
			ПоказатьПредупреждение( Оповещение, "Все ячейки заняты.", , "Ожидайте!" ); 
		ИначеЕсли Не Объект.НомерЯчейки = 0 И Объект.ЗакрытьЯчейку = Ложь И Объект.Номер = "" Тогда  
			Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
			ПоказатьПредупреждение( Оповещение, "Ваш номер ячейки: " + Объект.НомерЯчейки, , "Инфо" );
			//ЗаписатьВРегистрИспользованияЯчеек();
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ЗакрытьЯчейку = Истина И Не Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Нельзя закрыть ячеку пока заказ не готов.", , "Внимание!" ); 	
		Объект.ЗакрытьЯчейку = Ложь;
		Отказ = Истина;
	ИначеЕсли Объект.ЗакрытьЯчейку = Истина И Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда
		ЗаписатьВРегистрИспользованияЯчеек();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СостояниеЗаказаПриИзмененииНаСервере()

	Если Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.Готов Тогда
		Объект.ДатаВыполненияЗаказа = ТекущаяДата();
	Иначе
		Объект.ДатаВыполненияЗаказа = Дата(1,1,1);
	КонецЕсли;
	Если РольДоступна("ВыдачаПроектов") Тогда
		Если ПараметрыСеанса.ТекущийПользователь.Пользователь = Ложь И 
			(Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.Готов Или Объект.СостояниеЗаказа = Перечисления.СостояниеРемонта.Принят) Тогда 
			
			Объект.Принял = ПараметрыСеанса.ТекущийПользователь.Ссылка;
		Иначе 
			Объект.Принял = Справочники.Сотрудники.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаказаПриИзменении(Элемент)
	
	СостояниеЗаказаПриИзмененииНаСервере();
	Если Объект.Принял = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка") И (Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов")
		Или Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Принят")) Тогда
		
		Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Новый");
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Не выбран Исполнитель заявки.";
		Сообщение.Поле = "Объект.Принял";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСдачиВРаботуПриИзменении(Элемент)
	
	Если НачалоДня(Объект.ДатаСдачиВРаботу) < НачалоДня(ТекущаяДата()) Тогда 
		
		Объект.ДатаСдачиВРаботу = Дата(1,1,1);
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Дата сдачи должна быть посже или равно текущей дате.", , "Внимание!" );
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаСдачиВРаботуОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Объект.ДатаСдачиВРаботу = Дата(Год(ВыбранноеЗначение),Месяц(ВыбранноеЗначение),День(ВыбранноеЗначение),Час(ТекущаяДата()),Минута(ТекущаяДата()),0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Объект.Дата = ТекущаяДата();
	
	Записать();
	ПоказатьОповещениеПользователя("Изменение:",ПолучитьНавигационнуюСсылку(Объект.Ссылка), Объект.Ссылка,БиблиотекаКартинок.Информация);
	Если Модифицированность = Ложь Тогда 
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомнатаПриИзмененииНаСервере()
	
	 табличнаяЧастьКоби = Объект.Отдел.Кабинеты.Выгрузить();  
	 Объект.телефон = табличнаяЧастьКоби.Найти(Объект.Комната).ВнутреннийНомер;
	
КонецПроцедуры

&НаКлиенте
Процедура КомнатаПриИзменении(Элемент)
	КомнатаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверкаПередЗаписю()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КоличествоЯчеекНаВыдачеПроектов.КоличествоЯчеек КАК КоличествоЯчеек
		|ИЗ
		|	РегистрСведений.КоличествоЯчеекНаВыдачеПроектов КАК КоличествоЯчеекНаВыдачеПроектов
		|
		|УПОРЯДОЧИТЬ ПО
		|	КоличествоЯчеекНаВыдачеПроектов.Период УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		КоличествоЯчеек = ВыборкаДетальныеЗаписи.КоличествоЯчеек;
	КонецЕсли;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказЗаявкаРаспечатка.НомерЯчейки КАК НомерЯчейки,
	|	ЗаказЗаявкаРаспечатка.ЗакрытьЯчейку КАК ЗакрытьЯчейку
	|ИЗ
	|	Документ.ЗаказЗаявкаРаспечатка КАК ЗаказЗаявкаРаспечатка
	|ГДЕ
	|	ЗаказЗаявкаРаспечатка.НомерЯчейки <> 0
	|	И ЗаказЗаявкаРаспечатка.ЗакрытьЯчейку = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЯчейки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Сч = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Не ВыборкаДетальныеЗаписи.НомерЯчейки = Сч И Объект.НомерЯчейки = 0 И Сч < КоличествоЯчеек + 1 Тогда	
			Объект.НомерЯчейки = Сч;
			Объект.ЗакрытьЯчейку = Ложь;
		КонецЕсли;
		Сч=Сч + 1;
	КонецЦикла;
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда  
		Объект.НомерЯчейки = 1;
		Объект.ЗакрытьЯчейку = Ложь;
	ИначеЕсли Объект.НомерЯчейки = 0 И Сч < КоличествоЯчеек + 1 Тогда 			
		Объект.НомерЯчейки = ВыборкаДетальныеЗаписи.НомерЯчейки + 1;
		Объект.ЗакрытьЯчейку = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВРегистрИспользованияЯчеек()
	МенеджерЗаписи = РегистрыСведений.РегистрИспользованияЯчеек.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.НомерЯчейки = Объект.НомерЯчейки;
	МенеджерЗаписи.НазваниеОбъекта = Объект.НазваниеОбъекта;
	МенеджерЗаписи.Заказщик = Объект.ФИОЗаказчика;
	МенеджерЗаписи.ДатаОткрытияЯчейки = Объект.Дата;
	Если Объект.ЗакрытьЯчейку Тогда 
	МенеджерЗаписи.ДатаЗакрытияЯчейки = ТекущаяДата();
	МенеджерЗаписи.НомерЗакрыт = Объект.ЗакрытьЯчейку;
	КонецЕсли;
	МенеджерЗаписи.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЯчейкуПриИзменении(Элемент)
	Если Объект.ЗакрытьЯчейку = Истина И Не Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда 
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение( Оповещение, "Нельзя закрыть ячеку пока заказ не готов.", , "Внимание!" ); 	
		Объект.ЗакрытьЯчейку = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЯчейку(Команда)
	
	Если Не Объект.СостояниеЗаказа = ПредопределенноеЗначение("Перечисление.СостояниеРемонта.Готов") Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, "Нельзя закрыть ячейку.",,"Заказ Не ГОТОВ!");
		Элементы.ФормаЗакрытьЯчейку.Пометка = Ложь;
	КонецЕсли;
	
	Элементы.ФормаЗакрытьЯчейку.Пометка = Не Элементы.ФормаЗакрытьЯчейку.Пометка;
	Объект.ЗакрытьЯчейку = Элементы.ФормаЗакрытьЯчейку.Пометка;
	
КонецПроцедуры

&НаСервере
Функция ВыборТекста(ВыбранныеФайлы)  
	ПозицияКонец = СтрНайти(ВыбранныеФайлы,".",НаправлениеПоиска.СКонца,СтрДлина(ВыбранныеФайлы));
	Строкараз = Сред(ВыбранныеФайлы,0,ПозицияКонец-1);
	ПозицияНачало = СтрНайти(Строкараз,"\",НаправлениеПоиска.СКонца,СтрДлина(Строкараз));
	СтрокаОбрез = Сред(Строкараз,ПозицияНачало + 1);
	Возврат СтрокаОбрез;
 КонецФункции
