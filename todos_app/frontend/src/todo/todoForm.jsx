import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import Grid from '../template/grid';
import IconButton from '../template/iconButton';
import { add, changeDescription, search, clear } from './todoActions';

class TodoForm extends Component {
	constructor(props) {
		super(props);
		this.keyHandler = this.keyHandler.bind(this);
	}

	componentWillMount() {
		this.props.search();
	}

	keyHandler(e) {
		// destructuring operator of ES6
		// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
		const { add,  clear, search, description } = this.props;
		if(e.key === "Enter") {
			e.shiftKey ? search() : add(description);
		} else if(e.key === "Escape") {
			clear();
		}
	}

	render() {
		// destructuring operator of ES6
		// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
		const { add, clear, description, search } = this.props;
		return (
			<div role="form" className="todoForm">
				<Grid cols="12 9 10">
					<input id="description" className="form-control"
						placeholder="adicione uma tarefa"
						onChange={this.props.changeDescription}
						onKeyUp={this.keyHandler}
						value={this.props.description}></input>
				</Grid>
				<Grid cols="12 3 2">
					<IconButton style="primary" icon="plus"
						// arrow function to handle add TODO,
						// I must not call search directly
						onClick={() => add(description)} >
					</IconButton>
					<IconButton style="search" icon="search"
						onClick={() => search()}>			 
					</IconButton>
					<IconButton style="default" icon="close"
						onClick={clear}>
					</IconButton>
				</Grid>
			</div>			
		);
	}
}

const mapStateToProps = state => ({description: state.todo.description});
const matDispatchToProps = dispatch =>
	bindActionCreators({ add, changeDescription, search, clear }, dispatch);
export default connect(mapStateToProps, matDispatchToProps)(TodoForm);