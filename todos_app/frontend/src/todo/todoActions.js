import axios from 'axios';

import { TODO_CONSTANTS } from './todoConstants';

export const changeDescription = event => ({
	type: TODO_CONSTANTS.DESCRIPTION_CHANGED,
	payload: event.target.value
});

export const search = (description) => {
	// redux thunk to acces getState function
	return (dispatch, getState) => {
		// get the values of the description from
		// state to pass as parameter of XHR
		const description = getState().todo.description;
		const search = description ? `&description__regex=/${description}/` : "";
		axios.get(`${TODO_CONSTANTS.URL}?sort=-createdAt${search}`)
			// after the response was resolved
			// call the search action
			// thanks redux-thunk
			.then(r => dispatch({ type: TODO_CONSTANTS.TODO_SEARCHED, payload: r.data }));
	};
};

export const add = (description) => {
	// with redux thunk I can acces the 
	// dispatch to chain actions in a desired order
	return dispatch => {
		axios.post(TODO_CONSTANTS.URL, { description })
			.then( r => dispatch(clear()))
			.then( r2 => dispatch(search()))
	};
};

export const markAsDone = (todo) => {
	return dispatch => {
		axios.put(`${TODO_CONSTANTS.URL}/${todo._id}`, { ...todo, done: true })
			.then( r2 => dispatch(search()))
	};
};

export const markAsPending = (todo) => {
	return dispatch => {
		axios.put(`${TODO_CONSTANTS.URL}/${todo._id}`, { ...todo, done: false })
			.then( r2 => dispatch(search()))
	};
};

export const remove = (todo) => {
	return dispatch => {
		axios.delete(`${TODO_CONSTANTS.URL}/${todo._id}`)
			.then( r2 => dispatch(search()))
	};
};

export const clear = () => {
	// through redux-multi I can
	// dispatch muiltiple actions
	return [{ type: TODO_CONSTANTS.TODO_CLEAR }, search()];
};