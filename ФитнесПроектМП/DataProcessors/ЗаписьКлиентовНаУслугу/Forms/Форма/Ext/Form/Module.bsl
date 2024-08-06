﻿&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Услуга) Тогда
		Объект.Стоимость = ПолучитьЦенуНаСервере(Объект.Услуга)
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЦенуНаСервере(Услуги)
	
	Возврат Услуги.Стоимость

КонецФункции

&НаСервере
Процедура ЗаписатьсяНаСервере()
	
	ЗаписьКлиента = Документы.ЗаписьКлиента.СоздатьДокумент();
	ЗаписьКлиента.Дата = НачалоМинуты(Объект.ДатаЗаписи);
	ЗаписьКлиента.Сотрудник = Объект.Сотрудник;
	
	СтрокаУслуги = ЗаписьКлиента.Услуги.Добавить();
	СтрокаУслуги.Услуга = Объект.Услуга;
	СтрокаУслуги.Стоимость = Объект.Стоимость;
	
	СтруктураРеквизитовДокумента = Новый Структура;
	СтруктураРеквизитовДокумента.Вставить("ДатаЗаписи", Объект.ДатаЗаписи);
	СтруктураРеквизитовДокумента.Вставить("Сотрудник", Строка(Объект.Сотрудник));
	СтруктураРеквизитовДокумента.Вставить("GUIDПользователя", ПараметрыСеанса.ТекущийПользователь.ВнешнийGUID);
	
	МассивУслуг = Новый Массив;
	
	Услуга = Новый Структура;
	Услуга.Вставить("Услуга", Строка(Объект.Услуга));
	Услуга.Вставить("Цена", Объект.Стоимость);
	Услуга.Вставить("Количество", 1);
	Услуга.Вставить("Сумма", Объект.Стоимость);
	
	МассивУслуг.Добавить(Услуга);
	СтруктураРеквизитовДокумента.Вставить("МассивУслуг", МассивУслуг);
	
	СтруктураРеквизитовДокументаJSON = ОбменСОсновнойБазойВызовСервер.ПолучитьТекстJSON(СтруктураРеквизитовДокумента);
	
	ДокументУспешноОтправлен = ОбменСОсновнойБазойВызовСервер.ОтправитьЗаписьВЦентральнуюБазу(СтруктураРеквизитовДокументаJSON);
	Если ДокументУспешноОтправлен Тогда        
		ЗаписьКлиента.Записать(РежимЗаписиДокумента.Проведение);
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрШаблон("Вы записаны на услугу %1, к тренеру %2, на дату %3",Объект.Услуга, Объект.Сотрудник, Формат(Объект.ДатаЗаписи, "ДФ='dd.MM.yyyy HH:mm'"));
		СообщениеПользователю.Сообщить();
		
		Объект.ДатаЗаписи = '00010101';
		Объект.Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
		Объект.Услуга = Справочники.Услуги.ПустаяСсылка();
		Объект.Стоимость = 0;    
	Иначе    
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не удалось отправить Запись!";
		СообщениеПользователю.Сообщить();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Записаться(Команда)
	
	Если Объект.ДатаЗаписи < ТекущаяДата() Тогда
		Сообщить("Выберите другую дату!");
	Иначе	
		ЗаписатьсяНаСервере();
	КонецЕсли;
	
КонецПроцедуры

