type AppPages = Array<string>;

type AppComponents = { [string]: Object };

declare type AppInfo = {
  pages: AppPages;
}

type AppInstance = { id: string, instance: Object }
