Процедура ПриКопировании(ОбъектКопирования)
	ФИОЗаказчика = Справочники.Сотрудники.ПустаяСсылка();
	Отдел = Справочники.Подразделения.ПустаяСсылка();
	Комната = "";
	Телефон = "";
	СостояниеЗаказа = Перечисления.СостояниеРемонта.Новый;
	Принял = Справочники.Сотрудники.ПустаяСсылка();
	ДатаВыполненияЗаказа = Дата(1,1,1);
	Комментарий = "";
	ВидРабот = Перечисления.СостояниеРемонта.ПустаяСсылка();
	ТабличнаяЧертежныхРабот.Очистить();  
	НомерЯчейки = 0;
	ЗакрытьЯчейку = Ложь;                	
КонецПроцедуры
