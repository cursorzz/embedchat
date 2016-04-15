import React from 'react';
import moment from 'moment';

import ListItem from 'material-ui/lib/lists/list-item';
// import Avatar from 'material-ui/lib/avatar';
import Popover from 'material-ui/lib/popover/popover';
import Card from 'material-ui/lib/card/card';
import CardText from 'material-ui/lib/card/card-text';

moment.locale(window.navigator.userLanguage || window.navigator.language);

const styles = {
  pullRight: {
    float: 'right',
    color: 'gray',
    fontSize: 'small',
  },
};

class ListItemMessage extends React.Component {
  constructor(props) {
    super(props);
    this.handleTouchTap = this.handleTouchTap.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.state = {
      open: false,
    };
  }

  avatar() {
    return this.shortName()[0].toUpperCase();
  }

  shortName() {
    if (this.props.currentUser === this.props.from) {
      return 'You';
    }
    if (this.props.from_name !== this.props.from) {
      return this.props.from_name;
    }
    if (this.props.from.length > 0) {
      return this.props.from.substring(0, 7);
    }
    return 'A';
  }

  handleTouchTap(event) {
    this.setState({
      open: !this.state.open,
      anchorEl: event.currentTarget,
    });
  }

  handleClose() {
    this.setState({
      open: false,
    });
  }

  render() {
    return (
      <div>
        <ListItem
          secondaryTextLines={this.props.children.length > 15 ? 2 : 1}
          // leftAvatar={<Avatar>{this.avatar()}</Avatar>}
          primaryText={
            <div>
              {this.shortName()}
              <span style={styles.pullRight}>
                {moment.utc(this.props.createdAt).fromNow()}
              </span>
            </div>
          }
          onTouchTap={this.handleTouchTap}
          secondaryText={
            <div>
              {this.props.children}
            </div>
          }
        />
        <Popover
          open={this.state.open}
          anchorEl={this.state.anchorEl}
          anchorOrigin={{ horizontal: 'left', vertical: 'top' }}
          targetOrigin={{ horizontal: 'right', vertical: 'top' }}
          onRequestClose={this.handleClose}
        >
        <div>
          <Card>
            <CardText>
              { this.props.children }
            </CardText>
          </Card>
        </div>
        </Popover>
      </div>
    );
  }
}

ListItemMessage.propTypes = {
  currentUser: React.PropTypes.string.isRequired,
  from: React.PropTypes.string.isRequired,
  from_name: React.PropTypes.string.isRequired,
  createdAt: React.PropTypes.string.isRequired,
  children: React.PropTypes.string,
};

export default ListItemMessage;
