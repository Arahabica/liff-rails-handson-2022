export type StampData = {
  id: number;
  key: string;
  name: string;
  front_image: string;
  back_image: string;
  imprinted: boolean;
}

export type StampPresentation = {
  key: string;
  color: string;
  position: {
    x: number;
    y: number;
  }
}

export type Stamp = {
  id: number;
  key: string;
  name: string;
  front_image: string;
  back_image: string;
  imprinted: boolean;
  color: string;
  position: {
    x: number;
    y: number;
  }
}
