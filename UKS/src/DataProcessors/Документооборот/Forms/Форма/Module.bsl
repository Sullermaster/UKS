
&НаСервере
Процедура СформироватьНаСервере()
	
	ПараметрыСоединенияСМикродок = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	ПараметрыСоединенияСМикродок.СтрокаСоединения= "
	|DRIVER={MySQL ODBC 5.3 Unicode Driver};
	|SERVER=192.168.0.127;
	|DATABASE=micdoc;
	|UID=micdoc3;
	|PWD=665814";
	//|STMT=SET CHARACTER SET utf8";
	
	ВнешниеИсточникиДанных.Документооборот.УстановитьОбщиеПараметрыСоединения(ПараметрыСоединенияСМикродок);
	ВнешниеИсточникиДанных.Документооборот.УстановитьСоединение();
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	users.names КАК names
		|ИЗ
		|	ВнешнийИсточникДанных.Документооборот.Таблица.users КАК users";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	//Таблица = РезультатЗапроса.Выгрузить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	//
	////}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА


КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере2();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере2()
	
	СтрокаСоединения= "
	|DRIVER={MySQL ODBC 5.3 ANSI Driver};
	|SERVER=192.168.0.127;
	|DATABASE=micdoc;
	|UID=micdoc3;
	|PWD=665814;
	|STMT=SET CHARACTER SET utf8";
	
	Connection = Новый COMОбъект("ADODB.Connection");
	
	Connection.Open(СтрокаСоединения);


	RS = Новый COMОбъект("ADODB.Recordset"); 
	RS.CursorType=3;
	// Запрос к базе на языке SQL запросов.
	RS.ActiveConnection=Connection;
	RS.Open("select * from users");
	//Перемещаем указатель на первую запись.
	RS.MoveFirst(); 
	Пока RS.EOF()=0 Цикл
    	// Обрабатываем значения полей выборки.
    	NAM = RS.Fields("us_names").Value;
		
    	Сообщить(NAM);
    	// Перемещаем указатель.
    	RS.MoveNext();
	
	КонецЦикла;    
	//Закрываем соединения.
	RS.Close();
	Connection.Close();
	
КонецПроцедуры	