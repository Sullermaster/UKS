
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	//Вставить содержимое обработчика.
	//СтандартнаяОбработка = Ложь;
	//Поля.Добавить("Номер");
	//Поля.Добавить("Дата");
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	//Вставить содержимое обработчика.
	//СтандартнаяОбработка = Ложь;
	//Представление = Метаданные.ВнешниеИсточникиДанных.Документооборот.Таблицы.delo.Представление()
	//	+ " " + Строка(Данные.Номер) + НСтр("ru=' от '") + Формат(Данные.Дата, "ДЛФ=Д");
КонецПроцедуры
