#Область Методы

Функция ПроверитьПользователяЧата(Чат) 
	ИД = ФорматироватьСтроку(Чат.id);
	Если Справочники.ИДПользователейТелеграма.НайтиПоКоду(ИД,Истина)=Справочники.ИДПользователейТелеграма.ПустаяСсылка() Тогда
		Попытка
			НовыйЭлемент = Справочники.ИДПользователейТелеграма.СоздатьЭлемент();
			НовыйЭлемент.Код = ИД;
			НовыйЭлемент.Наименование = Чат.last_name+" "+Чат.first_name;
			НовыйЭлемент.Записать();
		Исключение	
		КонецПопытки;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСпиокСообщений() Экспорт
	
	Результат = getUpdates(Константы.update_id.Получить() + 1);
	
	Если Результат.Свойство("ok") И Результат.ok = Истина Тогда
		Если Результат.Свойство("result") Тогда
			Для каждого НовоеСообщение Из Результат.result Цикл
				Если НовоеСообщение.Свойство("message") И НовоеСообщение.message.Свойство("chat") Тогда
					chat = НовоеСообщение.message.chat;	
					id = chat.id;
					ПроверитьПользователяЧата(chat);
					Если НовоеСообщение.message.text = "/help" Тогда
						Сообщение = "Я чат бот, приветствую вас!" + Символы.ПС +
						"Для получения лицензий:" + Символы.ПС +
						"Заканчивающихся /lic" + Символы.ПС +
						"Действующих /act" + Символы.ПС+
						"Для получения отчета по архивам:"+Символы.ПС+
						"Не выполненных /noarh"+Символы.ПС+
						"Новых заявок /neworder"+Символы.ПС+
						"Введите /list для отображения кнопок команд";
						sendMessage(id, Сообщение);
					ИначеЕсли НовоеСообщение.message.text = "/lic" Тогда
						СписокЛицензий = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьОтчетПоЛицензиям(СписокЛицензий);
						Если СписокЛицензий.Количество()>0 Тогда
							Для Каждого СтрокаЛицензии Из СписокЛицензий Цикл
								sendMessage(id,СтрокаЛицензии);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет заканчивающихся лицензий!");
						КонецЕсли;
					ИначеЕсли НовоеСообщение.message.text = "/act" Тогда	
						СписокЛицензий = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьОтчетПоЛицензиямДействующим(СписокЛицензий);
						Если СписокЛицензий.Количество()>0 Тогда
							Для Каждого СтрокаЛицензии Из СписокЛицензий Цикл
								sendMessage(id,СтрокаЛицензии);
							КонецЦикла;
						Иначе	
							sendMessage(id,"Нет действующих лицензий!");	
						КонецЕсли;
					ИначеЕсли НовоеСообщение.message.text = "/noarh" Тогда
						//ОбработчикФоновыеЗадания.ЗапуститьПроверкуАрхивовВФоне();
						СтрокаРезультат = ОбработчикФоновыеЗадания.ПолучитьСтрокуРезультатаПроверкиАрхива();
						Если СтрокаРезультат="" Тогда
							СтрокаРезультат = "Все архивные копии исправны на "+ТекущаяДата();
						КонецЕсли;
						sendMessage(id,СтрокаРезультат);
					ИначеЕсли НовоеСообщение.message.text = "/neworder" Тогда
						СписокЗаявок = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьСписокЗаявок(Перечисления.СостояниеРемонта.Новый,СписокЗаявок);
						Если СписокЗаявок.Количество()>0 Тогда
							Для Каждого СтрокаЗаявки Из СписокЗаявок Цикл
								sendMessage(id,СтрокаЗаявки);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет новых заявок!");
						КонецЕсли;
					ИначеЕсли НовоеСообщение.message.text = "/acceptedorder" Тогда
						СписокЗаявок = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьСписокЗаявок(Перечисления.СостояниеРемонта.Принят,СписокЗаявок);
						Если СписокЗаявок.Количество()>0 Тогда
							Для Каждого СтрокаЗаявки Из СписокЗаявок Цикл
								sendMessage(id,СтрокаЗаявки);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет новых заявок!");
						КонецЕсли;	
					ИначеЕсли НовоеСообщение.message.text="заявка" Тогда
						//chat = НС.message.chat;
                        //id = chat.id;
                        Строки = Новый Массив;
                        Кнопки = Новый Массив;
                        Кнопки.Добавить(Новый Структура("text,callback_data","Показать прайс","prays"));
                        Кнопки.Добавить(Новый Структура("text,callback_data","Сделать заказ","zakaz"));
                        Строки.Добавить(Кнопки);
                        КлавиатураВСообщении = СформироватьJSON(Новый Структура("inline_keyboard",Строки),Ложь);
					   //КлавиатураВСообщении = СформироватьJSON(Новый Структура("keyboard,resize_keyboard=Истина",Строки),Ложь);
					   sendMessage(id, "",,,,,КлавиатураВСообщении);
					ИначеЕсли НовоеСообщение.message.text="/list" Тогда
						Строки = Новый Массив;
						Кнопки = Новый Массив;
						
						Кнопки.Добавить(Новый Структура("text,callback_data","Заканчивающиеся лицензии","/lic"));
						Строки.Добавить(Кнопки);
						
						Кнопки = Новый Массив;
						Кнопки.Добавить(Новый Структура("text,callback_data","Действующие лицензии","/act"));
						Строки.Добавить(Кнопки);
						
						Кнопки = Новый Массив;
						Кнопки.Добавить(Новый Структура("text,callback_data","Не сделанных архивов","/noarh"));
						Строки.Добавить(Кнопки);
						
						Кнопки = Новый Массив;
						Кнопки.Добавить(Новый Структура("text,callback_data","Новые заявки","/neworder"));
						Строки.Добавить(Кнопки);
						
						Кнопки = Новый Массив;
						Кнопки.Добавить(Новый Структура("text,callback_data","Принятые заявки","/acceptedorder"));
						Строки.Добавить(Кнопки);
						
						КлавиатураВСообщении = СформироватьJSON(Новый Структура("inline_keyboard",Строки),Ложь);
					//КлавиатураВСообщении = СформироватьJSON(Новый Структура("keyboard,resize_keyboard=Истина",Строки),Ложь);
						sendMessage(id, "Я получил ваше сообщение. Для просмотра команд введите /help"+Символы.ПС+"Или активируйте необходимую кнопку!",,,,,КлавиатураВСообщении);
					Иначе
						sendMessage(id, "Я получил ваше сообщение. Для просмотра команд введите /help");
					КонецЕсли;
					Константы.update_id.Установить(НовоеСообщение.update_id);
				ИначеЕсли НовоеСообщение.Свойство("callback_query") Тогда
					ТекстКнопки = НовоеСообщение.callback_query.data;
					chat = НовоеСообщение.callback_query.from;
					id = chat.id;
					ПроверитьПользователяЧата(chat);
					Если ТекстКнопки = "/lic" Тогда 	
						СписокЛицензий = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьОтчетПоЛицензиям(СписокЛицензий);
						Если СписокЛицензий.Количество()>0 Тогда
							Для Каждого СтрокаЛицензии Из СписокЛицензий Цикл
								sendMessage(id,СтрокаЛицензии);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет заканчивающихся лицензий!");
						КонецЕсли;
					ИначеЕсли ТекстКнопки = "/act" Тогда	
						СписокЛицензий = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьОтчетПоЛицензиямДействующим(СписокЛицензий);
						Если СписокЛицензий.Количество()>0 Тогда
							Для Каждого СтрокаЛицензии Из СписокЛицензий Цикл
								sendMessage(id,СтрокаЛицензии);
							КонецЦикла;
						Иначе	
							sendMessage(id,"Нет действующих лицензий!");
						КонецЕсли;
					ИначеЕсли ТекстКнопки = "/noarh" Тогда
						СтрокаРезультат = ОбработчикФоновыеЗадания.ПолучитьСтрокуРезультатаПроверкиАрхива();
						Если СтрокаРезультат="" Тогда
							СтрокаРезультат = "Все архивные копии исправны на "+ТекущаяДата();
						КонецЕсли;
						sendMessage(id,СтрокаРезультат);
					ИначеЕсли ТекстКнопки = "/neworder" Тогда
						СписокЗаявок = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьСписокЗаявок(Перечисления.СостояниеРемонта.Новый,СписокЗаявок);
						Если СписокЗаявок.Количество()>0 Тогда
							Для Каждого СтрокаЗаявки Из СписокЗаявок Цикл
								sendMessage(id,СтрокаЗаявки);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет новых заявок!");
						КонецЕсли;
					ИначеЕсли ТекстКнопки = "/acceptedorder" Тогда
						СписокЗаявок = Неопределено;
						ОбработчикФоновыеЗадания.СформироватьСписокЗаявок(Перечисления.СостояниеРемонта.Принят,СписокЗаявок);
						Если СписокЗаявок.Количество()>0 Тогда
							Для Каждого СтрокаЗаявки Из СписокЗаявок Цикл
								sendMessage(id,СтрокаЗаявки);
							КонецЦикла;
						Иначе
							sendMessage(id,"Нет принятых заявок!");
						КонецЕсли;	
					КонецЕсли;
					Константы.update_id.Установить(НовоеСообщение.update_id);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат Результат;
КонецФункции
 
#КонецОбласти 

#Область TelegramAPI

// Функция - Get updates
//
// Параметры:
//  offset	 - 	 - 
//  limit	 - 	 - 
//  timeout	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция getUpdates(offset = 0, limit = 0, timeout = 0) Экспорт
	
	method_param = Новый Массив;
	Если offset > 0 Тогда
		method_param.Добавить("offset=" + ФорматироватьСтроку(offset));
	КонецЕсли; 
	Если limit > 0 Тогда
		method_param.Добавить("limit=" + ФорматироватьСтроку(limit));
	КонецЕсли; 
	Если timeout > 0 Тогда
		method_param.Добавить("timeout=" + ФорматироватьСтроку(timeout));
	КонецЕсли; 
	
	Результат = ОтправитьHTTPЗапрос(ПолучитьAccessToken(), "getUpdates", method_param);
	
	Возврат ОбработатьJSON(Результат);
КонецФункции

// Функция - Send message
//
// Параметры:
//  chat_id					 - 	 - 
//  text					 - 	 - 
//  parse_mode				 - 	 - 
//  disable_web_page_preview - 	 - 
//  disable_notification	 - 	 - 
//  reply_to_message_id		 - 	 - 
//  reply_markup			 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция sendMessage(chat_id, text, parse_mode = Неопределено, disable_web_page_preview = Неопределено, disable_notification = Неопределено, reply_to_message_id = 0, reply_markup = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(chat_id) ИЛИ НЕ ЗначениеЗаполнено(text) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	method_param = Новый Массив;
	method_param.Добавить("chat_id=" + ФорматироватьСтроку(chat_id));
	method_param.Добавить("text=" + text);
	Если НЕ parse_mode = Неопределено Тогда
		method_param.Добавить("parse_mode=" + parse_mode);
	КонецЕсли; 
	Если НЕ disable_web_page_preview = Неопределено Тогда
		method_param.Добавить("disable_web_page_preview=" + disable_web_page_preview);
	КонецЕсли; 
	Если НЕ disable_notification = Неопределено Тогда
		method_param.Добавить("disable_notification=" + disable_notification);
	КонецЕсли; 
	Если reply_to_message_id > 0 Тогда
		method_param.Добавить("reply_to_message_id=" + ФорматироватьСтроку(reply_to_message_id));
	КонецЕсли; 
	Если НЕ reply_markup = Неопределено Тогда
		method_param.Добавить("reply_markup=" + reply_markup);
	КонецЕсли; 
	
	Результат = ОтправитьHTTPЗапрос(ПолучитьAccessToken(), "sendMessage", method_param);
	
	Возврат ОбработатьJSON(Результат);
КонецФункции

Функция sendDocument(chat_id, document, caption = Неопределено, disable_notification = Неопределено, reply_to_message_id = 0, reply_markup = Неопределено, ИмяФайлаПолное) Экспорт
	
	Если НЕ ЗначениеЗаполнено(chat_id) Тогда
		Возврат Неопределено;
	КонецЕсли; 	
	
	method_param = Новый Массив;
	method_param.Добавить("chat_id=" + ФорматироватьСтроку(chat_id));
	
	ДлинаИмени = СтрДлина(ИмяФайлаПолное) - СтрНайти(ИмяФайлаПолное, "\", НаправлениеПоиска.СКонца);
	ИмяФайла = Прав(ИмяФайлаПолное, ДлинаИмени);
	
	Данные = Новый Соответствие;
	Данные.Вставить("Boundary", "----" + Строка(Новый УникальныйИдентификатор));
	Данные.Вставить("ИмяФайлаПолное", ИмяФайлаПолное);
	Данные.Вставить("ИмяФайла", ИмяФайла);
	Данные.Вставить("name", "document");
	
	Результат = ОтправитьHTTPЗапрос(ПолучитьAccessToken(), "sendDocument", method_param, Данные);
	
	Возврат ОбработатьJSON(Результат);
КонецФункции

Функция sendPhoto(chat_id, photo, caption = Неопределено, disable_notification = Неопределено, reply_to_message_id = 0, reply_markup = Неопределено, ИмяФайлаПолное) Экспорт
	Если НЕ ЗначениеЗаполнено(chat_id) Тогда
		Возврат Неопределено;
	КонецЕсли; 	
	
	method_param = Новый Массив;
	method_param.Добавить("chat_id=" + ФорматироватьСтроку(chat_id));
	
	ДлинаИмени = СтрДлина(ИмяФайлаПолное) - СтрНайти(ИмяФайлаПолное, "\", НаправлениеПоиска.СКонца);
	ИмяФайла = Прав(ИмяФайлаПолное, ДлинаИмени);
	
	Данные = Новый Соответствие;
	Данные.Вставить("Boundary", "----" + Строка(Новый УникальныйИдентификатор));
	Данные.Вставить("ИмяФайлаПолное", ИмяФайлаПолное);
	Данные.Вставить("ИмяФайла", ИмяФайла);
	Данные.Вставить("name", "photo");
	
	Результат = ОтправитьHTTPЗапрос(ПолучитьAccessToken(), "sendPhoto", method_param, Данные);
	
	Возврат ОбработатьJSON(Результат);
КонецФункции
 
#КонецОбласти 

#Область WEB

#Область Интерфейс

Функция ОтправитьHTTPЗапрос(access_token, method, method_param = Неопределено, Данные = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	Попытка
		ssl = Новый ЗащищенноеСоединениеOpenSSL();
		
		//Прокси = Новый ИнтернетПрокси;
		//Прокси.Установить("https", Константы.Прокси.Получить(), Константы.Порт.Получить());
		
		СоединениеHTTP = Новый HTTPСоединение(Константы.Сервер.Получить(),443,,,,,ssl);
		
		ПараметрыЗапроса = Новый Соответствие;
		ПараметрыЗапроса.Вставить("access_token", access_token);
		ПараметрыЗапроса.Вставить("method", method);
		ПараметрыЗапроса.Вставить("method_param", method_param);
		
		HTTPЗапрос = Новый HTTPЗапрос;
		Если Данные = Неопределено Тогда
			HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
		Иначе
			HTTPЗапрос.Заголовки.Вставить("Content-type", "multipart/form-data; boundary=" + Данные["Boundary"]);
			
			ТекстЗапроса = СформироватьТекстЗапроса(Данные);
			HTTPЗапрос.УстановитьТелоИзСтроки(ТекстЗапроса, КодировкаТекста.ANSI, ИспользованиеByteOrderMark.НеИспользовать);
		КонецЕсли; 
		HTTPЗапрос.АдресРесурса = СформироватьМетод(ПараметрыЗапроса);
		
		Если Данные = Неопределено Тогда
			РезультатЗапроса = СоединениеHTTP.Получить(HTTPЗапрос);
		Иначе	
			РезультатЗапроса = СоединениеHTTP.ОтправитьДляОбработки(HTTPЗапрос);
		КонецЕсли; 
		
		Если РезультатЗапроса.КодСостояния = 200 Тогда
			Результат = РезультатЗапроса.ПолучитьТелоКакСтроку();
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = РезультатЗапроса.ПолучитьТелоКакСтроку();
			Сообщение.Сообщить(); 
		КонецЕсли; 
		
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить(); 
	КонецПопытки; 
	
	Возврат Результат;
КонецФункции
 
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция СформироватьМетод(ПараметрыЗапроса)
	Стр = "";
	ПараметрыМетода = "";
	
	// Переделать формирование строки с методом и параметрами под конкретный API
	// данная реализация для ВКонтакте
	Если ЗначениеЗаполнено(ПараметрыЗапроса["method_param"]) Тогда
		Для каждого Строка Из ПараметрыЗапроса["method_param"] Цикл
			ПараметрыМетода = ПараметрыМетода + Строка + "&";
		КонецЦикла; 
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПараметрыМетода) Тогда
		Стр = "bot" + ПараметрыЗапроса["access_token"] + "/" + ПараметрыЗапроса["method"] + "?";
		Стр = Стр + ПараметрыМетода;
	Иначе
		Стр = "bot" + ПараметрыЗапроса["access_token"] + "/" + ПараметрыЗапроса["method"];
	КонецЕсли; 
	
	Возврат Стр;
КонецФункции
 
Функция СформироватьJSON(СтруктураДанных, ФормироватьСПереносами = Ложь) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	Если ФормироватьСПереносами Тогда
		ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(, Символы.Таб));
	Иначе
		ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, Символы.Таб));
	КонецЕсли; 
	
	НастройкиСериализацииJSON = Новый НастройкиСериализацииJSON;
	НастройкиСериализацииJSON.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДатаСоСмещением;
	НастройкиСериализацииJSON.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	
	ЗаписатьJSON(ЗаписьJSON, СтруктураДанных, НастройкиСериализацииJSON);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции
 
Функция ОбработатьJSON(СтрокаJSON) Экспорт
	СтруктураВозврата = Новый Структура;
	
	Попытка
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(СтрокаJSON);
		
		СтруктураВозврата = ПрочитатьJSON(Чтение);
	Исключение
	КонецПопытки; 
	
	Возврат СтруктураВозврата;
КонецФункции
 
Функция ЗаписатьЛог(Данные) Экспорт
	Попытка
		ИмяФайлаЛога = ПолучитьПутьКФайлуЛога();
		ФайлЛога = Новый Файл(ИмяФайлаЛога);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		Если НЕ ФайлЛога.Существует() Тогда
			ТекстовыйДокумент.ДобавитьСтроку(Данные);
		Иначе
			ТекстовыйДокумент.Прочитать(ИмяФайлаЛога);
			ТекстовыйДокумент.ДобавитьСтроку(Данные);
		КонецЕсли; 
		ТекстовыйДокумент.Записать(ИмяФайлаЛога);
	Исключение
	КонецПопытки; 
КонецФункции
 
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",",
    Знач ПропускатьПустыеСтроки = Неопределено) Экспорт
 
    Результат = Новый Массив;
 
    // для обеспечения обратной совместимости
    Если ПропускатьПустыеСтроки = Неопределено Тогда
        ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
        Если ПустаяСтрока(Строка) Тогда 
            Если Разделитель = " " Тогда
                Результат.Добавить("");
            КонецЕсли;
            Возврат Результат;
        КонецЕсли;
    КонецЕсли;
    //
 
    Позиция = Найти(Строка, Разделитель);
    Пока Позиция > 0 Цикл
        Подстрока = Лев(Строка, Позиция - 1);
        Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
            Результат.Добавить(Подстрока);
        КонецЕсли;
        Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
        Позиция = Найти(Строка, Разделитель);
    КонецЦикла;
 
    Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
        Результат.Добавить(Строка);
    КонецЕсли;
 
    Возврат Результат;
 
КонецФункции

Функция ФорматироватьСтроку(ТекущееЗначение) Экспорт
	Возврат Формат(ТекущееЗначение, "ЧРГ=''; ЧГ=0");
КонецФункции

Функция СформироватьТекстЗапроса(Данные)
	
	ТекстЗапроса = "";
	
	ТекстЗапроса = ТекстЗапроса + "--" + Данные["Boundary"] + Символы.ВК + Символы.ПС;
	ТекстЗапроса = ТекстЗапроса + "Content-Disposition: form-data; name=""" + Данные["name"] + """; filename=""" + Данные["ИмяФайла"] + """" + Символы.ВК + Символы.ПС;
	ТекстЗапроса = ТекстЗапроса + "Content-Type: application/x-zip-compressed" + Символы.ВК + Символы.ПС + Символы.ВК + Символы.ПС; 
	
	ДвоичныеДанныеСтрокой = ПолучитьДвоичныеДанныеВСтрокуБезКодирования(Данные["ИмяФайлаПолное"]);
	
	ТекстЗапроса = ТекстЗапроса + ДвоичныеДанныеСтрокой + Символы.ВК + Символы.ПС;
	
	ТекстЗапроса = ТекстЗапроса + "--" + Данные["Boundary"] + "--" + Символы.ВК + Символы.ПС;
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ПолучитьДвоичныеДанныеВСтрокуБезКодирования(ИмяФайлаПолное)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайлаПолное, КодировкаТекста.ANSI, Символы.ПС);
	
	Возврат ТекстовыйДокумент.ПолучитьТекст();
КонецФункции
 
#КонецОбласти 

#Область Переопределяемые

Функция ПолучитьAccessToken()
	Возврат Константы.Токен.Получить();
КонецФункции

Функция ПолучитьПутьКФайлуЛога()
	Возврат Константы.ПутьЛогФайлаБота.Получить();
КонецФункции
 
#КонецОбласти

#КонецОбласти 

 