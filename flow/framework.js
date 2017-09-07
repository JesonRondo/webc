type AppPages = Array<string>;

type AppComponents = { [string]: Object };

declare type AppInfo = {
  pages: AppPages;
}

type AppPageInstance = { id: string, instance: Object }
