import { NativeModules } from 'react-native';

type RangersApplogReactnativePluginType = {
  multiply(a: number, b: number): Promise<number>;
};

const { RangersApplogReactnativePlugin } = NativeModules;

export default RangersApplogReactnativePlugin as RangersApplogReactnativePluginType;
