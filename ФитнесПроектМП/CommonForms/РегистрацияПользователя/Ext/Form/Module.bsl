﻿&НаКлиенте
Процедура Зарегистрироваться(Команда)
	
	Если ЭтаФорма.Логин = "" Тогда 
		Сообщить("Введите логин!");
		Возврат;
	ИначеЕсли ЭтаФорма.Телефон = "" Тогда
		Сообщить("Введите телефон!");
		Возврат;
	ИначеЕсли ЭтаФорма.Логин = "" И ЭтаФорма.Телефон = "" Тогда
		Сообщить("Введите логин и телефон!")
	КонецЕсли;
	
	АутентификацияИАвторизацияВызовСервер.ВыполнитьРегистрацию(ЭтаФорма.Логин, ЭтаФорма.Телефон);
	ЗавершитьРаботуСистемы(Ложь,Истина);
	
КонецПроцедуры
