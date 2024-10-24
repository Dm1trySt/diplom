## Crontab

[Whenever](https://github.com/javan/whenever) - gem, который позволяет писать задания для cron, используя красивый DSL.

Задания для cron хранятся в файле `plugins/instruments/config/schedule.rb`.

После измения этого файла необходимо выполнить `rake project:crontab:update` 

Для проверки можно использовать `rake project:crontab:show` - преобразует `schedule.rb` в синтаксис crontab и выведет, не обновляя crontab.

Как прописывать конкретную дату и время для cron:  
`┌───────────── minute (0 - 59)`   
`│ ┌───────────── hour (0 - 23)`   
`│ │ ┌───────────── day of the month (1 - 31)`   
`│ │ │ ┌───────────── month (1 - 12)`   
`│ │ │ │ ┌───────────── day of the week (0 - 6)`   
`│ │ │ │ │`   
`* * * * * <your rake>`   
