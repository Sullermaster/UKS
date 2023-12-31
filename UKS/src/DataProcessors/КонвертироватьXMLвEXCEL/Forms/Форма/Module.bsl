// Разбивает строку на несколько строк по указанному разделителю. Разделитель может иметь любую длину.
// В случаях, когда разделителем является строка из одного символа, и не используется параметр СокращатьНепечатаемыеСимволы,
// рекомендуется использовать функцию платформы СтрРазделить.
//
// Параметры:
//  Значение               - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Пример:
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",")
//  - возвратит массив из 5 элементов, три из которых  - пустые: "", "один", "", "два", "";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина)
//  - возвратит массив из двух элементов: "один", "два";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(" один   два  ", " ")
//  - возвратит массив из двух элементов: "один", "два";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("")
//  - возвратит пустой массив;
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("",,Ложь)
//  - возвратит массив с одним элементом: ""(пустая строка);
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("", " ")
//  - возвратит массив с одним элементом: "" (пустая строка).
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, 
	СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Значение) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = СтрНайти(Значение, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Значение, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Значение = Сред(Значение, Позиция + СтрДлина(Разделитель));
		Позиция = СтрНайти(Значение, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Значение) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Значение));
		Иначе
			Результат.Добавить(Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВыполнитьКонвертациюНаСервере(АдресВХранилище,Расширение)
	
	ФайлОбработкиXML = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	ФайлОбработкиXML.Записать(ИмяВременногоФайла);
	
	КонвертацияФайловСервер.РазобратьXML(Объект.ЗначенияДанных,ИмяВременногоФайла);
	
КонецПроцедуры

&НаКлиенте 
Процедура Подключить(УстановитьЕслиНеПодключено) Экспорт
    НачатьПодключениеРасширенияРаботыСФайлами(
        Новый ОписаниеОповещения(
            "ПослеПодключения",
            ЭтотОбъект,
            УстановитьЕслиНеПодключено));
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключения(Подключено, УстановитьЕслиНеПодключено) Экспорт
    Если Подключено Тогда
        // Расширение работы с файлами подключено

    ИначеЕсли УстановитьЕслиНеПодключено Тогда
        НачатьУстановкуРасширенияРаботыСФайлами(
            Новый ОписаниеОповещения(
                "Подключить",
                ЭтотОбъект,
                Ложь));
    Иначе
        // Не удалось установить или подключить

        // расширение работы с файлами

    КонецЕсли;    
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПомещения(ОписаниеПомещенногоФайла,ДополнительныеПараметры) Экспорт

	АдресВоВременномХранилище = ОписаниеПомещенногоФайла.Адрес;
	Расширение = СтрЗаменить(ОписаниеПомещенногоФайла.СсылкаНаФайл.Расширение,".","");
	ВыполнитьКонвертациюНаСервере(АдресВоВременномХранилище,Расширение);
	
	//ВыгрузитьВExcel();
	ЗаписатьТабличныйДокумент();
	//СформироватьТД();
	
КонецПроцедуры // ЗавершениеПомещения()

&НаКлиенте
Процедура ХодПомещения(ПомещаемыйФайл,Помещено,ОтказОтПомещенияФайла,ДополнительныеПараметры) Экспорт

КонецПроцедуры // ХодПомещения()

&НаКлиенте
Процедура ПередНачаломПомещения(ПомещаемыйФайл,ОтказОтПомещенияФайла,ДополнительныеПараметры) Экспорт

КонецПроцедуры // ПередНачаломПомещения()

&НаКлиенте
Процедура ВыполнитьКонвертацию(Команда)
		
	//СкоректироватьФайл();
	Объект.ЗначенияДанных.Очистить();
	
	ФайлВыбора = Новый Файл(Объект.ПутьКФайлу);
	Расширение = ФайлВыбора.Расширение;
	ИмяФайла = ФайлВыбора.ИмяБезРасширения;
	КаталогФайла = ФайлВыбора.Путь;
	АдресВоВременномХранилище = "" ;
	ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ЗавершениеПомещения",ЭтотОбъект);
	ОписаниеОповещенияОХодеВыполнения = Новый ОписаниеОповещения("ХодПомещения",ЭтотОбъект);
	ОписаниеОповещенияПередНачалом = Новый ОписаниеОповещения("ПередНачаломПомещения",ЭтотОбъект);
	
//	#Если ВебКлиент Тогда
		НачатьПомещениеФайлаНаСервер(ОписаниеОповещенияОЗавершении,ОписаниеОповещенияОХодеВыполнения,ОписаниеОповещенияПередНачалом,АдресВоВременномХранилище,Объект.ПутьКФайлу,УникальныйИдентификатор);
//	#Иначе		
//		ДанныеФайла = Новый ДвоичныеДанные(Объект.ПутьКФайлу);
//		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеФайла,УникальныйИдентификатор);
//	#КонецЕсли	
	//Сообщить(АдресВоВременномХранилище);
	
КонецПроцедуры

&НаСервере
Процедура СкоректироватьФайл()
	
	//<?xml version="1.0" encoding="windows-1251"?>
	ТекстXML = Новый ТекстовыйДокумент();
	ТекстXML.Прочитать(Объект.ПутьКФайлу);
	ТекстXML.ЗаменитьСтроку(1,"<?xml version=""1.0"" encoding=""windows-1251""?>");
	ТекстXML.Записать(Объект.ПутьКФайлу);
	
КонецПроцедуры // СкоректироватьФайл()

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ВебКлиент Тогда
		Подключить(Истина);	
	#КонецЕсли	

	Проводник = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Проводник.Заголовок = "Выберите файл";
	Проводник.Фильтр = "Табличный документ GXL|*.gxl|Табличный документ XML|*.xml";
	Проводник.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораФайла",ЭтотОбъект);
	
	Проводник.Показать(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы,ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПутьКФайлу = ВыбранныеФайлы[0];
	
	
КонецПроцедуры // ПослеВыбораФайла()

&НаСервере
Процедура ВыгрузитьВExcel()
	
	Если Объект.ЗначенияДанных.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
      
    // Загрузка объекта Microsoft Excel
   // 	Состояние("Выгрузка данных из 1С в Microsoft Excel...");
    	ExcelПриложение = Новый COMОбъект("Excel.Application");
    Исключение
	    Сообщить("Ошибка при запуске Microsoft Excel."
         + Символы.ПС + ОписаниеОшибки(), СтатусСообщения.Внимание);
        Возврат;
    КонецПопытки;
	
	 // Создадим книгу, по умолчанию в ней уже есть листы
	Книга = ExcelПриложение.WorkBooks.Add();
	
	// Используем первый лист книги Excel
    Лист = Книга.WorkSheets(1);
    // Сформировать шапку документа в первой строке листа
	Лист.Cells(1,1).Value = "Номер скважины";
	НомерСтроки = 2;
    Для Каждого Строка из Объект.ЗначенияДанных цикл
    	Лист.Cells(НомерСтроки,1).Value = Строка.Наименование;
		Лист.Cells(НомерСтроки,2).Value = Строка.Значение0;
		Лист.Cells(НомерСтроки,3).Value = Строка.Значение1;
		Лист.Cells(НомерСтроки,4).Value = Строка.Значение2;
		Лист.Cells(НомерСтроки,5).Value = Строка.Значение3;
		Лист.Cells(НомерСтроки,6).Value = Строка.Значение4;
		НомерСтроки = НомерСтроки+1;
	КонецЦикла;
	ЗаписьЖурналаРегистрации("Выгрузка.Обработка.КонвертироватьXMLвEXCEL",УровеньЖурналаРегистрации.Информация,Обработки.КонвертироватьXMLвEXCEL,,"Выгрузка файла");

	ExcelПриложение.Visible = Истина; 
 	//ExcelПриложение.Activate(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Подключить(Истина);	
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция СформироватьТД()
	
	Таблица = Новый ТабличныйДокумент;
	Макет = Обработки.КонвертироватьXMLвEXCEL.ПолучитьМакет("МакетВыгрузки");
	//ОбработкаОбъект = РеквизитФормыВЗначение(Объект);
	//Макет = ОбработкаОбъект.ПолучитьМакет("МакетВыгрузки");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	Для Каждого СтрокаТабЗначений Из Объект.ЗначенияДанных Цикл
		ОбластьСтрока.Параметры.Заполнить(СтрокаТабЗначений);
		Таблица.Вывести(ОбластьСтрока);	
	КонецЦикла;
	ЗаписьЖурналаРегистрации("Формирование.Обработка.КонвертироватьXMLвEXCEL",УровеньЖурналаРегистрации.Информация,Обработки.КонвертироватьXMLвEXCEL,,"Формирование файла");
	Возврат Таблица;
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораФайлаСохранения(ВыбранныеФайлы,ДополнительныеПараметры) Экспорт
	
	
	Если ВыбранныеФайлы=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Записать(ВыбранныеФайлы[0],ТипФайлаТабличногоДокумента.XLSX);
	
	ПоказатьОповещениеПользователя("Сохранение",,"Файл "+ВыбранныеФайлы[0]+" СОХРАНЕН!",БиблиотекаКартинок.Оповещения,,); 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТабличныйДокумент()
	
	ТабличныйДокумент = СформироватьТД();
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	ДиалогВыбора.Заголовок = "Выберите файл XLSX";
	ДиалогВыбора.Фильтр = "Лист Excel (*.xlsx)|*.xlsx";
	ДиалогВыбора.МножественныйВыбор = Ложь;
	ДиалогВыбора.Каталог = КаталогФайла;
	ДиалогВыбора.ПолноеИмяФайла = ИмяФайла;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораФайлаСохранения",ЭтотОбъект,ТабличныйДокумент);
	
	ДиалогВыбора.Показать(Оповещение);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаписьЖурналаРегистрации("Запуск.Обработка.КонвертироватьXMLвEXCEL",УровеньЖурналаРегистрации.Информация,Обработки.КонвертироватьXMLвEXCEL,,"Запуск обработки");
	
КонецПроцедуры
