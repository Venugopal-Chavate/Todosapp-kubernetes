// const apiUrl = `http://${process.env.REACT_APP_BACKEND}:${process.env.REACT_APP_API_PORT}/api/todos`;
const apiUrl = `http://backend-service:3001/api/todos`;
export const TODO_CONSTANTS = {
	DESCRIPTION_CHANGED:"DESCRIPTION_CHANGED",
	TODO_SEARCHED: "TODO_SEARCHED",
	TODO_CLEAR: "TODO_CLEAR",
	URL: apiUrl
}