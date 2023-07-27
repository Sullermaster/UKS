&НаСервере
Процедура ПолучитьОписаниеСтроки(ЭлементТекущаяСтрока)
	Если ЭлементТекущаяСтрока=Неопределено Тогда
		СтрокаОписание = "";
		Элементы.ОписаниеОборудования.Заголовок = СтрокаОписание;
		Возврат;
	КонецЕсли;	
	
	Если ЭлементТекущаяСтрока.ЭтоГруппа Тогда
		СтрокаОписание = "Группа: "+Врег(ЭлементТекущаяСтрока.Наименование);	
	Иначе
		Если ЗначениеЗаполнено(ЭлементТекущаяСтрока.ОтветственноеЛицо) Тогда
	    	СтрокаОписание = "Ответственный: "+Врег(ЭлементТекущаяСтрока.ОтветственноеЛицо)+
					" // "+Врег(ЭлементТекущаяСтрока.ОтветственноеЛицо.Должность)+
					" "+Врег(ЭлементТекущаяСтрока.ОтветственноеЛицо.Подразделение);
		Иначе
			СтрокаОписание = "НЕ НАЗНАЧЕН СОТРУДНИК";
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.ОписаниеОборудования.Заголовок = СтрокаОписание;
	
	Если СтрокаОписание="НЕ НАЗНАЧЕН СОТРУДНИК" Тогда
		Элементы.ОписаниеОборудования.ЦветТекста = Новый Цвет(255, 0, 0);
	Иначе
		Элементы.ОписаниеОборудования.ЦветТекста = Новый Цвет();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()  
	
	ПолучитьОписаниеСтроки(Элементы.Список.ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 1, Истина);

КонецПроцедуры
