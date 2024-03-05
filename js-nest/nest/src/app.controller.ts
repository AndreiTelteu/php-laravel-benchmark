import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

type Product = {
  id: number
  name: string
  price: number
}

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
  
  @Get('/products')
  products(): Product[] {
    const products: Product[] = [
      { id: 1, name: 'Product 1', price: 100 },
      { id: 2, name: 'Product 2', price: 200 },
      { id: 3, name: 'Product 3', price: 300 },
    ];
    return products;
  }
}
