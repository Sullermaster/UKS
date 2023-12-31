&НаСервере
Функция ПолучитьМакетНаСервере(ОбъектСсылка,НаименованиеМакета) Экспорт
	
	Объект = ОбъектСсылка.ПолучитьОбъект();
	Макет = Объект.ПолучитьМакет(НаименованиеМакета);
	Возврат Макет;
	
КонецФункции

&НаКлиенте
Процедура ДокументПоказать(ДокументWord, РежимПросмотраДокумента = 3) Экспорт
	
	Если ТипЗнч(ДокументWord) = Тип("ДвоичныеДанные") Тогда
		#Если НЕ ВебКлиент Тогда
		ФайлИмя = ПолучитьИмяВременногоФайла(".docx");
		#Иначе
		// Попытаемся подключить расширение работы с файлами.
		Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
			УстановитьРасширениеРаботыСФайлами();
			Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
				ВызватьИсключение "Ваш браузер не поддерживает работу с файлами.";
			КонецЕсли;
		КонецЕсли;
		// Сгенерируем уникальное имя временного файла для веб-клиента.
		Счетчик = 0;
		Файл = Новый Файл(КаталогВременныхФайлов() + ПолучитьРазделительПути() + "v8_tmp_word_file.docx");
		Пока Файл.Существует() Цикл
			Счетчик = Счетчик + 1;
			Файл = Новый Файл(КаталогВременныхФайлов() + ПолучитьРазделительПути() + "v8_tmp_word_file_"+Формат(Счетчик,"ЧЦ=4; ЧН=0000; ЧВН=; ЧГ=0")+".docx");
		КонецЦикла;
		ФайлИмя = Файл.ПолноеИмя;
		#КонецЕсли
		ДокументWord.Записать(ФайлИмя);
	ИначеЕсли ТипЗнч(ДокументWord) = Тип("Строка") Тогда
		ФайлИмя = ДокументWord;
	Иначе
		ВызватьИсключение "В процедуру УправлениеПечатьюКлиентСервер.ДокументПоказать(...) переданы некорректные аргументы: аргумент ДокументWord: Непредусмотренный тип данных ("+ТипЗнч(ДокументWord)+").";
	КонецЕсли;
	
	ОбъектВорд = Новый COMОбъект("Word.Application");
	ОбъектВорд.Visible = Истина;
	ОбъектВорд.Activate();
	ДокументВорд = ОбъектВорд.Documents.Open(ФайлИмя);
	ДокументВорд.Activate();
	ОбъектВорд.ActiveWindow.ActivePane.View.Type = РежимПросмотраДокумента;
	ОбъектВорд = Неопределено; // Освободим ссылку на запущенную версию Word'а (чтобы после закрытия он мог выгрузиться из памяти).
	
КонецПроцедуры
