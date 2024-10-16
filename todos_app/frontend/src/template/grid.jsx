import React, { Component } from 'react';

export default class Grid extends Component {

	toCssClasses(numbers) {
		const numbersArray = numbers ? numbers.split(' ') : []
		let classes = '';
		
		if (numbersArray[0]) classes += `col-xs-${numbersArray[0]}`;
		if (numbersArray[1]) classes += ` col-sm-${numbersArray[1]}`;
		if (numbersArray[2]) classes += ` col-md-${numbersArray[2]}`;
		if (numbersArray[3]) classes += ` col-ld-${numbersArray[3]}`;

		return classes;
	}

	render() {
		const colClasses = this.toCssClasses(this.props.cols || '12');
		return (
			<div className={colClasses}>
				{this.props.children}
			</div>	
		);
	}
}