
&НаСервере
Процедура ПериодОтбораПриИзмененииНаСервере()
	ДатаНачалаОтбора = ПериодОтбора.ДатаНачала;
	ДатаОкончанияОтбора = ПериодОтбора.ДатаОкончания;
	Если ПериодОтбора.ДатаНачала = Дата(1,1,1) Тогда
		ДатаНачалаОтбора = НачалоГода(ТекущаяДата());
	КонецЕсли;
	
	Если ПериодОтбора.ДатаОкончания = Дата(1,1,1) Тогда
		
		ДатаОкончанияОтбора = КонецГода(ТекущаяДата());
		
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачал",ДатаНачалаОтбора);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОконч",ДатаОкончанияОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтбораПриИзменении(Элемент)
	ПериодОтбораПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодОтбора.ДатаНачала = НачалоМесяца(ТекущаяДата());
	ПериодОтбора.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачал",ПериодОтбора.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОконч",ПериодОтбора.ДатаОкончания);

	ПодразделениеПриИзмененииНаСервере();
	
	ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"Проведен", Ложь,ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	
	ОтборНовый = Истина;
	ОтборПринятые = Истина;
	ОтборГотовые =  Истина;

	Если РольДоступна("ВыдачаПроектов") Тогда
		
	ИначеЕсли РольДоступна("Администратор") Тогда
		
	Иначе	
		Подразделение = ПараметрыСеанса.ТекущийПользователь.Подразделение;
		Элементы.КоличествоЯчеек.ТОлькоПросмотр = Истина;   
		Элементы.СохранениеИзмененияКоличестваЯчеек.Доступность = Ложь;
		Элементы.СохранениеИзмененияКоличестваЯчеек.Видимость = Ложь;
		Элементы.Настройка.Видимость = Ложь;
	КонецЕсли;

	ЗакрытыеПриИзмененииНаСервере();
	
	ОтборСостояниеЗаказа();

	ЗачеркнутьУдаленое(); 
	
	КоличествоЯчеекВРегистре();
		
КонецПроцедуры

&НаСервере
Процедура КоличествоЯчеекВРегистре()
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

КонецПроцедуры


&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	Если Подразделение = Справочники.Подразделения.ПустаяСсылка() Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"Отдел",);
	Иначе	
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"Отдел", Подразделение, ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТаблДок = ПечатьСписокЗаказоваНаСервере();
	                   
	ТаблДок.ОтображатьСетку = Ложь;
	ТаблДок.Защита = Истина;
	ТаблДок.АвтоМасштаб = Истина;
	ТаблДок.ТолькоПросмотр = Истина;
	ТаблДок.ОтображатьЗаголовки = Ложь;
	ТаблДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	ТаблДок.Показать();

КонецПроцедуры

&НаСервере
Функция ПечатьСписокЗаказоваНаСервере()
	ТаблДок = Новый ТабличныйДокумент;
   Макет = Документы.ЗаказЗаявкаРаспечатка.ПолучитьМакет("СписокЗаявок");
   
   Загл = Макет.ПолучитьОбласть("Заголов");
   
   Загл.Параметры.ДатаНачала = Формат(ПериодОтбора.ДатаНачала,"ДФ=dd.MM.yy");
   Загл.Параметры.ДатаОкончания = Формат(ПериодОтбора.ДатаОкончания,"ДФ=dd.MM.yy");
   ТаблДок.Вывести(Загл);  
   
   Шапка = Макет.ПолучитьОбласть("ШапкаЗаказы");
ТаблДок.Вывести(Шапка); 
   
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказЗаявкаРаспечатка.Дата КАК Дата,
		|	ЗаказЗаявкаРаспечатка.Номер КАК Номер,
		|	ЗаказЗаявкаРаспечатка.Отдел КАК Отдел,
		|	ЗаказЗаявкаРаспечатка.ФИОЗаказчика КАК ФИОЗаказчика,
		|	ЗаказЗаявкаРаспечатка.Комната КАК Комната,
		|	ЗаказЗаявкаРаспечатка.НазваниеОбъекта КАК НазваниеОбъекта,
		|	ЗаказЗаявкаРаспечатка.ВидРабот КАК ВидРабот,
		|	ЗаказЗаявкаРаспечатка.СостояниеЗаказа КАК СостояниеЗаказа,
		|	ЗаказЗаявкаРаспечатка.ДатаВыполненияЗаказа КАК ДатаВыполненияЗаказа,
		|	ЗаказЗаявкаРаспечатка.Принял КАК Принял
		|ИЗ
		|	Документ.ЗаказЗаявкаРаспечатка КАК ЗаказЗаявкаРаспечатка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
Стр = Макет.ПолучитьОбласть("Заказы");

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		//Стр.Параметры.номер = ВыборкаДетальныеЗаписи.НомерСтроки;
	    Стр.Параметры.Дата  = Формат(ВыборкаДетальныеЗаписи.Дата,"ДФ=dd.MM.yy");
	    Стр.Параметры.Номер = ВыборкаДетальныеЗаписи.Номер;
	    Стр.Параметры.Подразделение = ВыборкаДетальныеЗаписи.Отдел;
	    Стр.Параметры.Сотрудник = ВыборкаДетальныеЗаписи.ФИОЗаказчика;
	    Стр.Параметры.НомКаб = ВыборкаДетальныеЗаписи.Комната;
	    Стр.Параметры.НаимОбъ = ВыборкаДетальныеЗаписи.НазваниеОбъекта;
	    Стр.Параметры.ВидРаб = ВыборкаДетальныеЗаписи.ВидРабот; 	
	    Стр.Параметры.ЗакСос = ВыборкаДетальныеЗаписи.СостояниеЗаказа; 	
	    Стр.Параметры.ДатаВыполнения = Формат(ВыборкаДетальныеЗаписи.ДатаВыполненияЗаказа,"ДФ=dd.MM.yy"); 	
	    Стр.Параметры.ВыполнившийСотрудник = ВыборкаДетальныеЗаписи.Принял; 	
		ТаблДок.Вывести(Стр);
	КонецЦикла;

   Возврат ТаблДок;
КонецФункции

&НаСервере
Процедура ЗакрытыеПриИзмененииНаСервере()
	Если Закрытые = 2 Тогда
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"Проведен", Истина,ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	ИначеЕсли Закрытые =1 Тогда
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"Проведен", Ложь,ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	Иначе
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"Проведен",);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытыеПриИзменении(Элемент)
	ЗакрытыеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтборСостояниеЗаказа()
	
	Если ОтборНовый = Истина И ОтборПринятые = Истина И ОтборГотовые = Истина Тогда
		
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
	ИначеЕсли ОтборНовый = Истина И ОтборПринятые = Истина И ОтборГотовые = Ложь Тогда
		
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		МассивЗадач = Новый Массив;
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Новый);
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Принят);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", МассивЗадач,,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
		
	ИначеЕсли ОтборНовый = Истина И ОтборПринятые = Ложь И ОтборГотовые = Истина Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		МассивЗадач = Новый Массив;
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Новый);
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Готов);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", МассивЗадач,,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
		
	ИначеЕсли ОтборНовый = Ложь И ОтборПринятые = Истина И ОтборГотовые = Истина Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		МассивЗадач = Новый Массив;
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Готов);
		МассивЗадач.Добавить(Перечисления.СостояниеРемонта.Принят);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", МассивЗадач,,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
		
	ИначеЕсли ОтборНовый = Истина И ОтборПринятые = Ложь И ОтборГотовые = Ложь Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", Перечисления.СостояниеРемонта.Новый, ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	ИначеЕсли ОтборНовый = Ложь И ОтборПринятые = Истина И ОтборГотовые = Ложь Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", Перечисления.СостояниеРемонта.Принят, ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	ИначеЕсли ОтборНовый = Ложь И ОтборПринятые = Ложь И ОтборГотовые = Истина Тогда
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
		ОбщегоНазначенияНаСервере.УстановитьЭлементОтбораДинамическогоСписка(Список,"СостояниеЗаказа", Перечисления.СостояниеРемонта.Готов, ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
	ИначеЕсли ОтборНовый = Ложь И ОтборПринятые = Ложь И ОтборГотовые = Ложь Тогда
		
		ОбщегоНазначенияНаСервере.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СостояниеЗаказа",);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборНовыйПриИзменении(Элемент)
	ОтборСостояниеЗаказа();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПринятыеПриИзменении(Элемент)
	ОтборСостояниеЗаказа();
КонецПроцедуры

&НаКлиенте
Процедура ОтборГотовыеПриИзменении(Элемент)
	ОтборСостояниеЗаказа();
КонецПроцедуры

&НаСервере
Процедура ЗачеркнутьУдаленое() 
	
	ОбщегоНазначенияНаСервере.УстановитьСортировкуДинамическогоСписка(Список,"Дата",,НаправлениеСортировкиКомпоновкиДанных.Возр,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,);
		
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбора = ЭлементОФормления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,,Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ПровркаНаклиентк", 60);
КонецПроцедуры

&НаКлиенте
Процедура ПровркаНаклиентк()
	КоличествоЯчеекВРегистре();
КонецПроцедуры

&НаСервере
Процедура КоличествоЯчеекОткрытиеНаСервере()
	МенеджерЗаписи = РегистрыСведений.КоличествоЯчеекНаВыдачеПроектов.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.КоличествоЯчеек = КоличествоЯчеек;
	
	МенеджерЗаписи.Записать();
КонецПроцедуры

&НаКлиенте
Процедура СохранениеИзмененияКоличестваЯчеек(Команда)
	СтандартнаяОбработка = Ложь;
	КоличествоЯчеекОткрытиеНаСервере();
	ПоказатьОповещениеПользователя("Изменение:",,"Изменено количество ячеек на: " + КоличествоЯчеек, БиблиотекаКартинок.Информация );
КонецПроцедуры

&НаСервере
Процедура ЗакрытьЯчейкиНаСервере()

	Спск = Элементы.Список.ВыделенныеСтроки;
	Для каждого Стр из Спск Цикл
		
		Если Стр.СостояниеЗаказа = Перечисления.СостояниеРемонта.Готов И Стр.ЗакрытьЯчейку = Ложь И
			Не Стр.НомерЯчейки = 0 Тогда 
			
			ОбъектДля = Стр.Ссылка.ПолучитьОбъект();
			
			ОбъектДля.ЗакрытьЯчейку = Истина;
			ОбъектДля.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЯчейки(Команда)
	ЗакрытьЯчейкиНаСервере();
КонецПроцедуры
