import { combineReducers } from "redux";
import {reducer as toastr} from 'react-redux-toastr';
import proponents from "../components/proponents/reducer"

const rootReducer = combineReducers({
  proponents,
  toastr
});

export default rootReducer;
